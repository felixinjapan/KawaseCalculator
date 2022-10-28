//
//  FetchDataUseCaseTest.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation
import XCTest

final class FetchDataUseCaseTest: XCTestCase {

    func test_whenFetchBaseCurrencyEntityWithEntity_shouldNotBeEmpty() {
        // given
        let repoMock = RepositoryMock()
        let sut = DefaultFetchDataUseCase(repositoryContainer: repoMock)
        let base = "Test"
        let mockBaseCurrencyEntity = BaseCurrencyEntityMock(name: base)

        // when
        let result = sut.fetchBaseCurrencyEntity(baseCurrencyEntity: mockBaseCurrencyEntity)
        // then
        XCTAssertNotEqual(result.count, 0)
    }

    func test_whenFetchBaseCurrencyEntityWithBase_shouldReturnCorrectResult() {
        // given
        let repoMock = RepositoryMock()
        let sut = DefaultFetchDataUseCase(repositoryContainer: repoMock)
        let base = "Test"

        // when
        guard let result = sut.fetchBaseCurrencyEntity(base: base) else { XCTFail(); return }
        // then
        XCTAssertEqual(result.unWrappedBase, base)
    }

    func test_whenRequestCurrencyAPISuccess_shouldReturnCorrectResult() {
        // given
        let repoMock = RepositoryMock()
        let sut = DefaultFetchDataUseCase(repositoryContainer: repoMock)
        let expectedBase = "USD"
        let expectation = self.expectation(description: "Return a success response")
        let cancelBag = CancelBag()

        // when
        sut.requestCurrencyAPI()
            .sink(receiveCompletion: { completion in 
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    print(error)
                    XCTFail()
                }
            }, receiveValue: { res in
                XCTAssertEqual(res.base, expectedBase)
            }).store(in: cancelBag)
        // then
        wait(for: [expectation], timeout: 0.1)
    }

    @MainActor
    func test_whenLaunchOfflineModeSuccess_shouldReturnCorrectResult() {
        // given
        let repoMock = RepositoryMock()
        let sut = DefaultFetchDataUseCase(repositoryContainer: repoMock)
        let state = CalculatorState()
        state.inputValue = "1000"
        // when
        sut.launchOfflineMode(calculatorState: state)

        XCTAssertEqual(state.currencyMap.count, 1)
        XCTAssertEqual(state.selectedCurrencyRateList.count, 1)
    }

    @MainActor
    func test_whenLaunchOfflineModeNoDefaultBaseEntityFound_shouldReturnEmptyDataResult() {
        // given
        let repoMock = RepositoryMock()
        repoMock.coreDataRepository = CoreDataRepository_NoBaseEntityFoundMock()
        let sut = DefaultFetchDataUseCase(repositoryContainer: repoMock)
        let state = CalculatorState()
        state.inputValue = "1000"
        // when
        sut.launchOfflineMode(calculatorState: state)

        XCTAssertEqual(state.currencyMap.count, 0)
        XCTAssertEqual(state.selectedCurrencyRateList.count, 0)
    }

    @MainActor
    func test_whenLaunchOfflineModeListAlreadyExists_shouldReturnEmptyDataResult() {
        // given
        let repoMock = RepositoryMock()
        let sut = DefaultFetchDataUseCase(repositoryContainer: repoMock)
        let state = DevUtil.instance.calculatorStateFullStub
        let originalCount = state.selectedCurrencyRateList.count
        // when
        sut.launchOfflineMode(calculatorState: state)

        XCTAssertEqual(state.selectedCurrencyRateList.count, originalCount)
    }
}

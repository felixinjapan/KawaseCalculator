//
//  FetchDataUseCaseTest.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation
import XCTest

final class ContentViewModelTest: XCTestCase {

    func test_whenNetworkErrorOnFetchLastestRate_shouldTriggerOfflineMode() {
        // given
        let expectation = self.expectation(description: "Should trigger the launchOfflineMode")
        let networkFailCaseMock = FetchDataUseCase_OfflineModeMock()
        networkFailCaseMock.expectation = expectation
        let appDIContainer = AppDIContainer(respositoryContainer: RepositoryMock())
        appDIContainer.fetchCurrenciesUsecase = networkFailCaseMock
        appDIContainer.storeCurrencyUseCase = StoreCurrencyUseCaseMock()

        let state = CalculatorState()

        let sut = DefaultContentViewModel()
        sut.inject(with: appDIContainer, with: state)
        // when
        sut.fetchLatestRate()

        // then
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_whenFetchLastestRateGotCorrectResponse_shouldTriggerNormalMode() {
        // given
        let expectation = self.expectation(description: "Should trigger a normal flow")
        let successCaseMock = StoreCurrencyUseCaseMock()
        successCaseMock.expectation = expectation
        let appDIContainer = AppDIContainer(respositoryContainer: RepositoryMock())
        appDIContainer.fetchCurrenciesUsecase = FetchDataUseCaseMock()
        appDIContainer.storeCurrencyUseCase = successCaseMock
        appDIContainer.calculationCurrencyUseCase = CalculationCurrencyUseCaseMock()
        let state = CalculatorState()

        let sut = DefaultContentViewModel()
        sut.inject(with: appDIContainer, with: state)
        // when
        sut.fetchLatestRate()

        // then
        waitForExpectations(timeout: 5, handler: nil)
    }
}

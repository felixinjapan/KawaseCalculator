//
//  InputBoxViewModelTest.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation
import XCTest

@MainActor
final class InputBoxViewModelTest: XCTestCase {

    func test_whenLoadCurrencyDataSuccess_shouldUpdateCorrectState() {
        // given
        let sut = DefaultInputBoxViewModel()
        let repositoryMock = RepositoryMock()
        let base = "USD"
        let state = CalculatorState()
        state.inputValue = "1000"
        state.selectedCurrency = "USD"
        state.currentCurrency = "JPY"

        let appDIContainer = AppDIContainer(respositoryContainer: repositoryMock)
        appDIContainer.calculationCurrencyUseCase = CalculationCurrencyUseCaseMock()
        appDIContainer.fetchCurrenciesUsecase = FetchDataUseCaseMock()
        appDIContainer.storeCurrencyUseCase = StoreCurrencyUseCaseMock()
        sut.inject(with: appDIContainer, with: state)

        // when
        sut.loadCurrencyData(for: base)

        // then
        XCTAssertEqual(state.inputValue, "1000")
        XCTAssertEqual(state.selectedCurrency, "USD")
        XCTAssertEqual(state.currentCurrency, "USD")
        XCTAssertEqual(state.selectedCurrencyRateList.count, 1)

        XCTAssertEqual(state.currencyMap.count, 1)
        XCTAssertNotNil(state.currencyMap[base])
    }

    func test_whenLoadCurrencyDataWithNoChangeOnBase_shouldNotUpdateState() {
        // given
        let sut = DefaultInputBoxViewModel()
        let repositoryMock = RepositoryMock()
        let base = "USD"
        let state = CalculatorState()
        state.inputValue = "1000"
        state.selectedCurrency = "USD"
        state.currentCurrency = "USD"

        let appDIContainer = AppDIContainer(respositoryContainer: repositoryMock)
        appDIContainer.calculationCurrencyUseCase = CalculationCurrencyUseCaseMock()
        appDIContainer.fetchCurrenciesUsecase = FetchDataUseCaseMock()
        appDIContainer.storeCurrencyUseCase = StoreCurrencyUseCaseMock()
        sut.inject(with: appDIContainer, with: state)

        // when
        sut.loadCurrencyData(for: base)

        // then
        XCTAssertEqual(state.inputValue, "1000")
        XCTAssertEqual(state.selectedCurrency, "USD")
        XCTAssertEqual(state.currentCurrency, "USD")
        XCTAssertEqual(state.selectedCurrencyRateList.count, 0)

        XCTAssertEqual(state.currencyMap.count, 0)
        XCTAssertNil(state.currencyMap[base])
    }

    func test_whenLoadCurrencyDataDataAlreadyExist_shouldNotUpdateBaseEntityObject() {
        // given
        let sut = DefaultInputBoxViewModel()
        let repositoryMock = RepositoryMock()
        let base = "USD"
        let baseEntityMock = BaseCurrencyEntityMock(name: base)
        let state = CalculatorState()
        state.inputValue = "1000"
        state.selectedCurrency = "USD"
        state.currentCurrency = "KRW"
        state.currencyMap = [base: baseEntityMock]

        let appDIContainer = AppDIContainer(respositoryContainer: repositoryMock)
        appDIContainer.calculationCurrencyUseCase = CalculationCurrencyUseCaseMock()
        appDIContainer.fetchCurrenciesUsecase = FetchDataUseCaseMock()
        appDIContainer.storeCurrencyUseCase = StoreCurrencyUseCaseMock()
        sut.inject(with: appDIContainer, with: state)

        // when
        sut.loadCurrencyData(for: base)

        // then
        XCTAssertEqual(state.inputValue, "1000")
        XCTAssertEqual(state.selectedCurrency, "USD")
        XCTAssertEqual(state.currentCurrency, "USD")
        XCTAssertEqual(state.selectedCurrencyRateList.count, 1)

        XCTAssertEqual(state.currencyMap.count, 1)
        // Make sure no object created and injected
        XCTAssertIdentical(state.currencyMap[base], baseEntityMock)
    }
}

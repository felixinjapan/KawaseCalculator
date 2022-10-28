//
//  RefreshTimeCheckerTest.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation
import XCTest

final class StoreCurrencyUseCaseTest: XCTestCase {

    let entityDataBaseUSD = ["USD": 1,
                      "JPY": 144.739,
                      "KRW": 1440.23,
                      "EUR": 1.020055]

    let entityDataBaseKRW = ["USD": 0.0006943335439478416,
                      "JPY": 0.100497143,
                      "KRW": 1,
                      "EUR": 0.000708333]

    func test_whenSaveBaseCurrnecyEntity_shouldReturnCorrectResult() {
        // given
        let repoMock = RepositoryMock()
        let sut = DefaultStoreCurrencyUseCase(repositoryContainer: repoMock)
        let base = "Test"
        // when
        let result = sut.saveBaseCurrnecyEntity(with: base)
        // then
        XCTAssertEqual(result.unWrappedBase, base)
    }

    func test_whenSaveCurrencyEntities_shouldReturnCorrectResult() {
        // given
        let repoMock = RepositoryMock()
        let sut = DefaultStoreCurrencyUseCase(repositoryContainer: repoMock)
        let base = "Test"
        let mockBaseCurrencyEntity = BaseCurrencyEntityMock(name: base)

        let data = ["USD": 0.0006943335439478416,
                          "JPY": 0.100497143,
                          "KRW": 1,
                          "EUR": 0.000708333]
        let rates = data.map { Rate(symbol: $0.key, ratio: $0.value) }
        // when
        let result = sut.saveCurrencyEntities(baseCurrencyEntity: mockBaseCurrencyEntity, rates)
        // then
        XCTAssertEqual(result.count, 4)
        for currency in result {
            XCTAssertEqual(currency.rate, data[currency.unwrappedSymbol])
        }
    }

    @MainActor
    func test_whenSaveResponse_shouldReturnCorrectStateResult() {
        // given
        let repoMock = RepositoryMock()
        let sut = DefaultStoreCurrencyUseCase(repositoryContainer: repoMock)

        let state = CalculatorState()
        state.inputValue = "1000"

        let data = ["USD": 0.0006943335439478416,
                          "JPY": 0.100497143,
                          "KRW": 1,
                          "EUR": 0.000708333]
        let rates = data.map { Rate(symbol: $0.key, ratio: $0.value) }
        let currencyResponseMock = CurrencyResponse(rates: rates, base: Constants.UnitTest.testCurrency.rawValue)

        // when
        sut.saveResponse(res: currencyResponseMock, calculatorState: state)

        // then
        XCTAssertEqual(state.currencyMap.count, 1)
        XCTAssertEqual(state.selectedCurrency, currencyResponseMock.base)
        XCTAssertEqual(state.inputValue, "1000")
        XCTAssertEqual(state.selectedCurrencyRateList.count, data.count)
        for rate in state.selectedCurrencyRateList {
            XCTAssertEqual(rate.rate, data[rate.symbol!])
        }
    }
}

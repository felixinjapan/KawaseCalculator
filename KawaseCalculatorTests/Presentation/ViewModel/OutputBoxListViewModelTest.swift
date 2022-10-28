//
//  OutputBoxListViewModelTest.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation
import XCTest

final class OutputBoxListViewModelTest: XCTestCase {

    let rates = ["USD": 1,
                 "JPY": 144.739,
                 "KRW": 1440.23]

    let expected = ["JPY": "144739.00",
                    "KRW": "1440230.00",
                    "USD": "1000.00"]

    func test_whenGetAmountNormalCase_shouldReturnCorrectResult() {
        // given
        let sut = DefaultOutputBoxListViewModel()
        let repositoryMock = RepositoryMock()

        let state = CalculatorState()
        state.inputValue = "1000"
        let appDIContainer = AppDIContainer(respositoryContainer: repositoryMock)
        sut.inject(with: appDIContainer, with: state)
        // when
        for (symbol, rate) in rates {
            // then
            XCTAssertEqual(sut.getAmount(by: rate), expected[symbol])
        }
    }

    func test_whenGetAmountWithOneDecimal_shouldReturnCorrectResult() {
        // given
        let sut = DefaultOutputBoxListViewModel()
        let repositoryMock = RepositoryMock()

        let state = CalculatorState()
        state.inputValue = "1000.00"
        let appDIContainer = AppDIContainer(respositoryContainer: repositoryMock)
        sut.inject(with: appDIContainer, with: state)
        // when
        for (symbol, rate) in rates {
            // then
            XCTAssertEqual(sut.getAmount(by: rate), expected[symbol])
        }
    }

    func test_whenGetAmountWithTwoDecimal_shouldReturnNotAvailableResult() {
        // given
        let sut = DefaultOutputBoxListViewModel()
        let repositoryMock = RepositoryMock()

        let state = CalculatorState()
        state.inputValue = "1000..00"
        let appDIContainer = AppDIContainer(respositoryContainer: repositoryMock)
        sut.inject(with: appDIContainer, with: state)
        // when
        for (symbol, rate) in rates {
            // then
            XCTAssertEqual(sut.getAmount(by: rate), Constants.General.wrongAmount.rawValue)
            XCTAssertNotNil(expected[symbol])
        }
    }

    func test_whenGetAmountWithString_shouldReturnNotAvailableResult() {
        // given
        let sut = DefaultOutputBoxListViewModel()
        let repositoryMock = RepositoryMock()

        let state = CalculatorState()
        state.inputValue = "1fe0fe00..00"
        let appDIContainer = AppDIContainer(respositoryContainer: repositoryMock)
        sut.inject(with: appDIContainer, with: state)
        // when
        for (symbol, rate) in rates {
            // then
            XCTAssertEqual(sut.getAmount(by: rate), Constants.General.wrongAmount.rawValue)
            XCTAssertNotNil(expected[symbol])
        }
    }
}

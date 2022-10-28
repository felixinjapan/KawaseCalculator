//
//  RefreshTimeCheckerTest.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation
import XCTest

final class CalculationCurrencyUseCaseTest: XCTestCase {

//        FROM
//        "base": "USD", x
//        "rates": {
//          "JPY": 145,  // x1
//          "KRW": 1440,   // x2
//          "EUR": 1.02       // x3
//         }
//        TO
//         "base": KRW
//         "rates": {
//          "JPY": rate = x1/x2,    // 0.100497143
//          "EUR": rate = x3/x2,    // 0.000708333
//          "USD": rate = 1/x2 ,    // 0.000694444
//         }
    let entityDataBaseUSD = ["USD": 1,
                      "JPY": 144.739,
                      "KRW": 1440.23,
                      "EUR": 1.020055]

    let entityDataBaseKRW = ["USD": 0.0006943335439478416,
                      "JPY": 0.100497143,
                      "KRW": 1,
                      "EUR": 0.000708333]

    func test_whenCalculateFromUSDtoKRW_shouldReturnCorrectResult() {
        // given
        var entityList = [CurrencyEntityMock]()
        for (symbol, rate) in entityDataBaseUSD {
            entityList.append(CurrencyEntityMock(name: symbol, rate: rate))
        }
        let sut = DefaultCalculationCurrencyUseCase()
        // when
        let result = sut.calculate(entityList, to: "KRW")

        // then
        XCTAssertEqual(result.count, 3)
        for rate in result {
            if rate.symbol == "KRW" {
                XCTFail()
            }
            let lhr = precised(value: rate.ratio, 6)
            let rhs = precised(value: entityDataBaseKRW[rate.symbol]!, 6)
            XCTAssertEqual(lhr, rhs)
        }
    }

    func test_whenCalculateFromKRWtoUSD_shouldReturnCorrectResult() {
        // given
        var entityList = [CurrencyEntityMock]()
        for (symbol, rate) in entityDataBaseKRW {
            entityList.append(CurrencyEntityMock(name: symbol, rate: rate))
        }
        let sut = DefaultCalculationCurrencyUseCase()
        // when
        let result = sut.calculate(entityList, to: "USD")

        // then
        XCTAssertEqual(result.count, 3)
        for rate in result {
            if rate.symbol == "USD" {
                XCTFail()
            }
            let lhr = precised(value: rate.ratio, 2)
            let rhs = precised(value: entityDataBaseUSD[rate.symbol]!, 2)
            XCTAssertEqual(lhr, rhs)
        }
    }

    func test_whenCalculateWithMinMaxDoubleNumber_shouldNotFail() {
        // given
        let entityDataBaseUSD = ["USD": 1,
                                 "JPY": Double.greatestFiniteMagnitude,
                          "KRW": Double.leastNormalMagnitude,
                                 "EUR": Double.leastNonzeroMagnitude]
        var entityList = [CurrencyEntityMock]()
        for (symbol, rate) in entityDataBaseUSD {
            entityList.append(CurrencyEntityMock(name: symbol, rate: rate))
        }
        let sut = DefaultCalculationCurrencyUseCase()
        // when
        let result = sut.calculate(entityList, to: "USD")

        // then
        XCTAssertEqual(result.count, 3)
    }

    func test_whenCalculateFromUSDtoUSD_shouldReturnSameResult() {
        // given
        var entityList = [CurrencyEntityMock]()
        for (symbol, rate) in entityDataBaseUSD {
            entityList.append(CurrencyEntityMock(name: symbol, rate: rate))
        }
        let sut = DefaultCalculationCurrencyUseCase()
        // when
        let result = sut.calculate(entityList, to: "USD")

        // then
        XCTAssertEqual(result.count, 3)
        for rate in result {
            if rate.symbol == "USD" {
                XCTFail()
            }
            let lhr = precised(value: rate.ratio, 2)
            let rhs = precised(value: entityDataBaseUSD[rate.symbol]!, 2)
            XCTAssertEqual(lhr, rhs)
        }
    }

    func test_whenCalculateWithEmptyTargetBase_shouldReturnEmptyResult() {
        // given
        var entityList = [CurrencyEntityMock]()
        for (symbol, rate) in entityDataBaseUSD {
            entityList.append(CurrencyEntityMock(name: symbol, rate: rate))
        }
        let sut = DefaultCalculationCurrencyUseCase()
        // when
        let result = sut.calculate(entityList, to: "")

        // then
        XCTAssertEqual(result.count, 0)
    }

    // Round up double to `value` decimals
    private func precised(value: Double, _ precision: Int = 1) -> Double {
      let offset = pow(10, Double(precision))
      return (value * offset).rounded() / offset
    }

}

//
//  CalculationCurrencyUseCaseMock.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/02.
//

import Foundation

// MARK: Calculation Currency UseCase Mock - Normal

final class CalculationCurrencyUseCaseMock: CalculationCurrencyUseCase {
    func calculate(_ currencyEntity: [CurrencyEntity], to targetBase: String) -> [Rate] {
        let symbol = Constants.UnitTest.testCurrency.rawValue
        let ratio = Constants.UnitTestDouble.testRatio.rawValue
        return [Rate(symbol: symbol, ratio: ratio)]
    }
}

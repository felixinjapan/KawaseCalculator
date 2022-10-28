//
//  CalculationCurrencyUseCase.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/29.
//

import Foundation

// MARK: Calculation Currency UseCase
protocol CalculationCurrencyUseCase {
    func calculate(_ currencyEntity: [CurrencyEntity], to targetBase: String) -> [Rate]
}

final class DefaultCalculationCurrencyUseCase: CalculationCurrencyUseCase { }

// MARK: Calculation Currency UseCase Impl
extension DefaultCalculationCurrencyUseCase {
    func calculate(_ currencyEntity: [CurrencyEntity], to targetBase: String) -> [Rate] {
        var rateList = [Rate]()
        // Get the pivot rate for given base string
        let pivotRatelist = currencyEntity
            .filter({$0.unwrappedSymbol == targetBase})
            .map({ return $0.rate })
            
        guard !pivotRatelist.isEmpty, let pivotRate = pivotRatelist.first else { return rateList }
        
        rateList = currencyEntity
            .filter { $0.unwrappedSymbol != targetBase }
            .map { return Rate(symbol: $0.unwrappedSymbol, ratio: ($0.rate/pivotRate)) }
        return rateList
    }
}

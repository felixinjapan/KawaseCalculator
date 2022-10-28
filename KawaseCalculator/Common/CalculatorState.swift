//
//  CalculatorState.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation

final class CalculatorState {

    @Published var inputValue = Constants.General.emptyString.rawValue
    @Published var selectedCurrencyRateList = [CurrencyEntity]()
    @Published var selectedCurrency = Constants.General.emptyString.rawValue

    var currencyMap = [String: BaseCurrencyEntity]()
    var listOfCurrency: [String]? 
    var currentCurrency = Constants.General.emptyString.rawValue
}

extension CalculatorState: ObservableObject { }

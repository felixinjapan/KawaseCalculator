//
//  PreviewProvider.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/29.
//

import Foundation
import SwiftUI

final class DevUtil {
    // singleton
    static let instance = DevUtil()

    lazy var calculatorStateFullStub: CalculatorState = {
        let state = CalculatorState()
        state.inputValue = "1000"
        state.selectedCurrency = "USD"
        state.currentCurrency = "KRW"
        state.currencyMap = ["USD": BaseCurrencyEntityMock()]
        state.selectedCurrencyRateList = [CurrencyEntityMock]()
        state.selectedCurrencyRateList.append(CurrencyEntityMock(name: "ABC", rate: .random(in: 1...5)))
        state.selectedCurrencyRateList.append(CurrencyEntityMock(name: "DEF", rate: .random(in: 1...5)))
        state.selectedCurrencyRateList.append(CurrencyEntityMock(name: "GHI", rate: .random(in: 1...5)))
        return state
    }()

    // show the path for sqlite
    func printCoreDataSQLliteFileDirectory() {
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
}

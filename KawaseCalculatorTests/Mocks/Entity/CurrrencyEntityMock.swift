//
//  CurrrencyEntityMock.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/02.
//

import Foundation

final class CurrencyEntityMock: CurrencyEntity {
    convenience init(name: String = Constants.General.emptyString.rawValue, rate: Double = 0) {
        self.init()
        self.stubbedSymbol = name
        self.stubbedRate = rate
    }

    var stubbedSymbol: String = Constants.General.emptyString.rawValue
    override var symbol: String? {
        get {
            return stubbedSymbol
        }
        set {}
    }

    var stubbedRate: Double = 0
    override var rate: Double {
        get {
            return stubbedRate
        }
        set {}
    }
}

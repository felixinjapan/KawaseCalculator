//
//  BaseCurrencyEntityMock.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/02.
//

import Foundation

final class BaseCurrencyEntityMock: BaseCurrencyEntity {
    convenience init(name: String = Constants.General.emptyString.rawValue) {
        self.init()
        self.stubbedSymbol = name
    }

    var stubbedSymbol: String = Constants.General.emptyString.rawValue
    override var base: String? {
        get {
            return stubbedSymbol
        }
        set {}
    }
}

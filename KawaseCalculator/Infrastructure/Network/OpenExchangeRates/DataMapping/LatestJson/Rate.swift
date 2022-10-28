//
//  CurrencyResponse.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import Foundation

struct Rate: Decodable {
    let symbol: String
    let ratio: Double
    
    init(symbol: String, ratio: Double = 0) {
        self.symbol = symbol
        self.ratio = ratio
    }
}

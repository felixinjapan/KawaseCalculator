//
//  CurrencyResponse.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/27.
//

import Foundation

struct CurrencyResponse: Decodable {
    let rates: [Rate]
    let base: String

    enum CodingKeys: String, CodingKey {
        case rates
        case base
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.base = try container.decode(String.self, forKey: .base)
        let ratesMap = try container.decode([String: Double].self, forKey: .rates)
        rates = ratesMap.map { Rate(symbol: $0.key, ratio: $0.value) }
    }

    init(rates: [Rate], base: String) {
        self.rates = rates
        self.base = base
    }
}

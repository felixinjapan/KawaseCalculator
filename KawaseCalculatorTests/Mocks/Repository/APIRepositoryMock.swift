//
//  APIRepositoryMock.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/02.
//

import Foundation
import Combine

final class APIRepositoryMock: APIRepository {
    lazy var apiConfiguration: APIConfiguration = .init()

    func getRatesByBase() -> AnyPublisher<CurrencyResponse, Error> {
        let rateList = [Rate(symbol: Constants.UnitTest.testCurrency.rawValue, ratio: Constants.UnitTestDouble.testRatio.rawValue)]
        let currencyResponseMock = CurrencyResponse(rates: rateList, base: Constants.UnitTest.testCurrency.rawValue)
        return Just(currencyResponseMock).setFailureType(to: Error.self).eraseToAnyPublisher()    }
}

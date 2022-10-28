//
//  FetchDataUsecaseMock.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/27.
//

import Foundation
import Combine
import XCTest

// MARK: Fetch Data Usecase Mock - NORMAL

class FetchDataUseCaseMock: FetchDataUseCase {
    
    func launchOfflineMode(calculatorState: CalculatorState) {
        return
    }
    
    var repositoryContainer: RepositoryContainer = RepositoryMock()
    
    func requestCurrencyAPI() -> AnyPublisher<CurrencyResponse, Error> {
        let rateList = [Rate(symbol: Constants.UnitTest.testCurrency.rawValue, ratio: Constants.UnitTestDouble.testRatio.rawValue)]
        let currencyResponseMock = CurrencyResponse(rates: rateList, base: Constants.UnitTest.testCurrency.rawValue)
        return Just(currencyResponseMock).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchBaseCurrencyEntity(base: String) -> BaseCurrencyEntity? {
        return BaseCurrencyEntityMock(name: base)
    }
    
    func fetchBaseCurrencyEntity(baseCurrencyEntity: BaseCurrencyEntity) -> [CurrencyEntity] {
        let mock = CurrencyEntityMock(name: Constants.UnitTest.testCurrency.rawValue, rate: Constants.UnitTestDouble.testRatio.rawValue)
        return [mock]
    }
}

// MARK: Fetch Data UseCase - Offline Mode Mock

final class FetchDataUseCase_OfflineModeMock: FetchDataUseCaseMock {
    var expectation: XCTestExpectation?
    override func requestCurrencyAPI() -> AnyPublisher<CurrencyResponse, Error> {
        return Fail(error: AppError.NetworkError.tooManyApiCalls).eraseToAnyPublisher()
    }

    override func launchOfflineMode(calculatorState: CalculatorState) {
        expectation?.fulfill()
    }
}

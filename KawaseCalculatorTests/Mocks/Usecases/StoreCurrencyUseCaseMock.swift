//
//  StoreCurrencyUseCaseMock.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/02.
//

import Foundation
import XCTest

// MARK: Store Currency UseCase Mock - Normal

final class StoreCurrencyUseCaseMock: StoreCurrencyUseCase {
    var expectation: XCTestExpectation?

    func saveResponse(res: CurrencyResponse, calculatorState: CalculatorState) {
        if let expectation = expectation {
            expectation.fulfill()
        }
        return
    }

    var repositoryContainer: RepositoryContainer = RepositoryMock()

    func saveCurrencyEntities(baseCurrencyEntity: BaseCurrencyEntity, _ data: [Rate]) -> [CurrencyEntity] {
        let mock = CurrencyEntityMock(name: Constants.UnitTest.testCurrency.rawValue, rate: Constants.UnitTestDouble.testRatio.rawValue)
        return [mock]
    }

    func saveBaseCurrnecyEntity(with base: String) -> BaseCurrencyEntity {
       return BaseCurrencyEntityMock(name: Constants.UnitTest.testCurrency.rawValue)
    }
}

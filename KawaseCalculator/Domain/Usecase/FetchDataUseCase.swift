//
//  FetchAndStoreRateData.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/26.
//

import Foundation
import Combine
import CoreData
import os

// MARK: Fetch Data Usecase
protocol FetchDataUseCase {
    var repositoryContainer: RepositoryContainer { get }
    func requestCurrencyAPI() -> AnyPublisher<CurrencyResponse, Error>
    func fetchBaseCurrencyEntity(base: String) -> BaseCurrencyEntity?
    func fetchBaseCurrencyEntity(baseCurrencyEntity: BaseCurrencyEntity) -> [CurrencyEntity]
    func launchOfflineMode(calculatorState: CalculatorState)
}

final class DefaultFetchDataUseCase: FetchDataUseCase {
    
    let repositoryContainer: RepositoryContainer
    let logger = Logger(subsystem: Constants.Logging.subsystem.rawValue, category: String(describing: DefaultFetchDataUseCase.self))

    init(repositoryContainer: RepositoryContainer) {
        self.repositoryContainer = repositoryContainer
    }
}

// MARK: Fetch Data Usecase Impl
extension DefaultFetchDataUseCase {
    
    func requestCurrencyAPI() -> AnyPublisher<CurrencyResponse, Error> {
        return repositoryContainer.apiRepository.getRatesByBase()
    }

    func fetchBaseCurrencyEntity(baseCurrencyEntity: BaseCurrencyEntity) -> [CurrencyEntity] {
        return repositoryContainer.coreDataRepository.fetchCurrencyRates(baseCurrencyEntity: baseCurrencyEntity)
//        return baseCurrencyEntity.currencyArray
    }

    func fetchBaseCurrencyEntity(base: String) -> BaseCurrencyEntity? {
        return repositoryContainer.coreDataRepository.fetchBaseCurrencyEntity(base: base)
    }

    @MainActor
    func launchOfflineMode(calculatorState: CalculatorState) {
        let defaultBase = Constants.General.defaultCurrency.rawValue

        guard calculatorState.selectedCurrencyRateList.isEmpty else {
            logger.warning("Offline mode - Data is already loaded")
            return
        }

        // Fetch a list of currency entity using default base
        guard let baseCurrencyEntity = fetchBaseCurrencyEntity(base: defaultBase) else {
            logger.warning("Offline mode failed \(String(describing: AppError.CoreData.noLocalDataExists))")
            return
        }

        let currencyRateList = fetchBaseCurrencyEntity(baseCurrencyEntity: baseCurrencyEntity)
        // Update calculator state
        if calculatorState.listOfCurrency == nil {
            calculatorState.listOfCurrency = currencyRateList.map { $0.unwrappedSymbol }
        }
        calculatorState.selectedCurrencyRateList = currencyRateList
        calculatorState.selectedCurrency = defaultBase
        calculatorState.currencyMap[baseCurrencyEntity.unWrappedBase] = baseCurrencyEntity
        calculatorState.currentCurrency = baseCurrencyEntity.unWrappedBase
    }
}

//
//  StoreCurrencyUseCase.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/26.
//

import Foundation
import Combine

// MARK: Store Currency UseCase
protocol StoreCurrencyUseCase {
    var repositoryContainer: RepositoryContainer { get }
    func saveCurrencyEntities(baseCurrencyEntity: BaseCurrencyEntity, _ data: [Rate]) -> [CurrencyEntity]
    func saveBaseCurrnecyEntity(with base: String) -> BaseCurrencyEntity
    func saveResponse(res: CurrencyResponse, calculatorState: CalculatorState)
}

final class DefaultStoreCurrencyUseCase: StoreCurrencyUseCase {

    let repositoryContainer: RepositoryContainer
    
    init(repositoryContainer: RepositoryContainer) {
        self.repositoryContainer = repositoryContainer
    }
}
// MARK: Store Currency UseCase Impl
extension DefaultStoreCurrencyUseCase {
    
    func saveCurrencyEntities(baseCurrencyEntity: BaseCurrencyEntity, _ data: [Rate]) -> [CurrencyEntity] {
        var currencyList: [CurrencyEntity] = [CurrencyEntity]()
        for rate in data {
            let entity = repositoryContainer.coreDataRepository.insertCurrencyEntity(symbol: rate.symbol, rate: rate.ratio, baseCurrencyEntity: baseCurrencyEntity)
            currencyList.append(entity)
        }
        repositoryContainer.coreDataRepository.saveData()
        return currencyList
    }
    
    func saveBaseCurrnecyEntity(with base: String) -> BaseCurrencyEntity {
        let baseCurrencyEntity = repositoryContainer.coreDataRepository.insertBaseCurrencyEntity(base: base)
        repositoryContainer.coreDataRepository.saveData()
        return baseCurrencyEntity
    }

    @MainActor
    func saveResponse(res: CurrencyResponse, calculatorState: CalculatorState) {
        // Truncate entities to save the operation costs
        tearDownEntities()
        // Insert into coredata
        let baseCurrencyEntity = saveBaseCurrnecyEntity(with: res.base)
        let currencyRateList = saveCurrencyEntities(baseCurrencyEntity: baseCurrencyEntity, res.rates)
        // Update calculator state
        if calculatorState.listOfCurrency == nil {
            calculatorState.listOfCurrency = currencyRateList.map { $0.unwrappedSymbol }
        }
        calculatorState.selectedCurrencyRateList = currencyRateList
        calculatorState.selectedCurrency = res.base
        calculatorState.currencyMap[baseCurrencyEntity.unWrappedBase] = baseCurrencyEntity
        calculatorState.currentCurrency = baseCurrencyEntity.unWrappedBase
    }

    private func tearDownEntities() {
        repositoryContainer.coreDataRepository.batchDelete(entityName: Constants.Coredata.currencyEntity.rawValue)
        repositoryContainer.coreDataRepository.batchDelete(entityName: Constants.Coredata.baseCurrencyEntity.rawValue)
    }
}

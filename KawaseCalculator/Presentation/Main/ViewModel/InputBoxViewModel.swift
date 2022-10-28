//
//  InputBoxViewModel.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation
import os

// MARK: - InputBoxViewModel 
protocol InputBoxViewModel: ObservableObject {
    func loadCurrencyData(for base: String)
}

// MARK: - DefaultInputBoxViewModel
final class DefaultInputBoxViewModel: InputBoxViewModel {
    private var appDIContainer: AppDIContainer?
    private var calculatorState: CalculatorState?
    let logger = Logger(subsystem: Constants.Logging.subsystem.rawValue, category: String(describing: InputBoxView.self))
}

// MARK: - Method DI injection
extension DefaultInputBoxViewModel: ViewModelMethodInjectable {
    func inject(with appDIContainer: AppDIContainer, with calculatorState: CalculatorState) {
        self.appDIContainer = appDIContainer
        self.calculatorState = calculatorState
    }
}

// MARK: - ViewModel Implementation
extension DefaultInputBoxViewModel {

    @MainActor
    func loadCurrencyData(for base: String) {

        guard base.count > 0 else { return }

        guard let appDIContainer = self.appDIContainer, let calculatorState = self.calculatorState else { return }
        
        guard base != calculatorState.currentCurrency else { return }

        if let baseEntity = calculatorState.currencyMap[base] {
            // existing data
            calculatorState.selectedCurrencyRateList = appDIContainer.fetchCurrenciesUsecase.fetchBaseCurrencyEntity(baseCurrencyEntity: baseEntity)
            logger.debug("use existing data: \(base)")
        } else {
            // save base entity
            let baseCurrencyEntity = appDIContainer.storeCurrencyUseCase.saveBaseCurrnecyEntity(with: base)
            // get calculated rate list
            let rateList = appDIContainer.calculationCurrencyUseCase.calculate(calculatorState.selectedCurrencyRateList, to: base)
            // save currency entity
            calculatorState.selectedCurrencyRateList = appDIContainer.storeCurrencyUseCase.saveCurrencyEntities(baseCurrencyEntity: baseCurrencyEntity, rateList)
            calculatorState.currencyMap[baseCurrencyEntity.unWrappedBase] = baseCurrencyEntity
            logger.debug("calculation and store into coredata: \(base)")
        }
        // Intialize the list of currency only first time
        if calculatorState.listOfCurrency == nil {
            calculatorState.listOfCurrency = calculatorState.selectedCurrencyRateList.map { $0.unwrappedSymbol }
        }
        // update the previous currency
        calculatorState.currentCurrency = base
    }

    func getListofCurrency() -> [String] {
        guard let calculatorState = self.calculatorState, let list = calculatorState.listOfCurrency  else { return [String]() }
        return list
    }
}

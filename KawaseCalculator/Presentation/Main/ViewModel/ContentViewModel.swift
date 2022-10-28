//
//  ContentViewModel.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import Foundation
import Combine
import CoreData
import os

// MARK: - ContentViewModel
protocol ContentViewModel: ObservableObject {
    func fetchLatestRate()
}
// MARK: - DefaultContentViewModel
final class DefaultContentViewModel: ContentViewModel {
    private var appDIContainer: AppDIContainer?
    private var calculatorState: CalculatorState?
    private var cancelBag = CancelBag()
    let logger = Logger(subsystem: Constants.Logging.subsystem.rawValue, category: String(describing: DefaultContentViewModel.self))
}

// MARK: - Method DI injection
extension DefaultContentViewModel: ViewModelMethodInjectable {
    func inject(with appDIContainer: AppDIContainer, with calculatorState: CalculatorState) {
        self.appDIContainer = appDIContainer
        self.calculatorState = calculatorState
    }
}

// MARK: - ViewModel Implementation
extension DefaultContentViewModel {

    func fetchLatestRate() {
        guard let appDIContainer = self.appDIContainer else {
            logger.error("appDIContainer did not initialize and its nil")
            return
        }
        guard let calculatorState = self.calculatorState else {
            logger.error("calculatorState did not initialize and its nil")
            return
        }
        appDIContainer.fetchCurrenciesUsecase.requestCurrencyAPI()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self] in
                // MARK: - API [Failure] Offline mode
                if case let .failure(error) = $0 {
                    self.logger.warning("Failed API call. Continue as offline mode, fetching data from coredata. \(String(describing: error))")
                    appDIContainer.fetchCurrenciesUsecase.launchOfflineMode(calculatorState: calculatorState)
                }
            }, receiveValue: { res in
                // MARK: - API [Success] Handle updating
                appDIContainer.storeCurrencyUseCase.saveResponse(res: res, calculatorState: calculatorState)
            }).store(in: cancelBag)
    }
}

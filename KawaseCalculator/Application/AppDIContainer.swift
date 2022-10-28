//
//  AppDIContainer.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import Foundation

// MARK: - DIContainer

protocol DIContainer: ObservableObject {
    var repositoryContainer: RepositoryContainer { get }
}

// MARK: - AppDIContainer

final class AppDIContainer: DIContainer {
    let repositoryContainer: RepositoryContainer
    init (respositoryContainer: RepositoryContainer = DefaultRepositoryContainer()) {
        self.repositoryContainer = respositoryContainer
    }

    // use cases
    lazy var fetchCurrenciesUsecase: FetchDataUseCase = DefaultFetchDataUseCase(repositoryContainer: repositoryContainer)
    lazy var storeCurrencyUseCase: StoreCurrencyUseCase = DefaultStoreCurrencyUseCase(repositoryContainer: repositoryContainer)
    lazy var calculationCurrencyUseCase: CalculationCurrencyUseCase = DefaultCalculationCurrencyUseCase()
}

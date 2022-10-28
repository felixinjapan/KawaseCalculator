//
//  OutputBoxListViewModel.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation

// MARK: - OutputBoxListViewModel

protocol OutputBoxListViewModel: ObservableObject {
    func getAmount(by ratio: Double) -> String 
}

final class DefaultOutputBoxListViewModel: OutputBoxListViewModel {
    private var appDIContainer: AppDIContainer?
    private var calculatorState: CalculatorState?
}

// MARK: - Method DI injection
extension DefaultOutputBoxListViewModel: ViewModelMethodInjectable {
    func inject(with appDIContainer: AppDIContainer, with calculatorState: CalculatorState) {
        self.appDIContainer = appDIContainer
        self.calculatorState = calculatorState
    }
}

// MARK: - ViewModel Implementation
extension DefaultOutputBoxListViewModel {

    func getAmount(by ratio: Double) -> String {
        guard let calculatorState = self.calculatorState else { return Constants.General.wrongAmount.rawValue }
        // round up to two decimals
        if let input = Double(calculatorState.inputValue) {
            return String(format: "%.2f", ratio * input)
        }
        return Constants.General.wrongAmount.rawValue
    }
}

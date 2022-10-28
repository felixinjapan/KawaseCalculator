//
//  ContentView.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import SwiftUI
import os

struct ContentView: View {
    // Dependcies
    @EnvironmentObject var appDIContainer: AppDIContainer
    @EnvironmentObject var calculatorState: CalculatorState
    // Behaviour
    @StateObject private var scrollUpToRefreshViewModel = DefaultScrollUpToRefreshViewModel()
    // VM
    @StateObject private var viewModel = DefaultContentViewModel()
    let logger = Logger(subsystem: Constants.Logging.subsystem.rawValue, category: String(describing: ContentView.self))

    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    InputBoxView()
                    OutputBoxListView()
                }
                ScrollUpToRefreshBehaviour()
            }
        }
        .onPreferenceChange(ScrollOffsetPreference.self) {
            _=scrollUpToRefreshViewModel.didUpdateOffset($0)
        }
        .onChange(of: scrollUpToRefreshViewModel.isRefreshing) { isRefreshing in
            guard isRefreshing else { return }
            logger.debug("current state:::: \(calculatorState.inputValue), \(calculatorState.selectedCurrency)")
            viewModel.fetchLatestRate()
        }
        .onAppear {
            // method injection
            viewModel.inject(with: appDIContainer, with: calculatorState)
            viewModel.fetchLatestRate()
        }
    }
}
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()                .environmentObject(DevUtil.instance.calculatorStateFullStub)
                .environmentObject(AppDIContainer())
            .navigationBarHidden(true)
            ContentView()                .environmentObject(DevUtil.instance.calculatorStateFullStub)
                .environmentObject(AppDIContainer())
                .navigationBarHidden(true)
                .preferredColorScheme(.dark)
        }
    }
}
#endif

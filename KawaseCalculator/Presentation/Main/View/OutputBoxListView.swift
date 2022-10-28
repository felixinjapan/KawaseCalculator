//
//  OutputBoxView.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/26.
//

import SwiftUI

struct OutputBoxListView: View {
    // Dependcies
    @EnvironmentObject var appDIContainer: AppDIContainer
    @EnvironmentObject var calculatorState: CalculatorState
    
    // VM
    @StateObject private var viewModel = DefaultOutputBoxListViewModel()

    var body: some View {
        ForEach(calculatorState.selectedCurrencyRateList, id: \.self) {
            OutBoxView(symbol: $0.unwrappedSymbol, value: viewModel.getAmount(by: $0.rate))
        }
        .onAppear {
            viewModel.inject(with: appDIContainer, with: calculatorState)
        }
    }
}
#if DEBUG
struct OutputBoxListView_Preview: PreviewProvider {
    static var previews: some View {
        OutputBoxListView().environmentObject(DevUtil.instance.calculatorStateFullStub)
            .environmentObject(AppDIContainer())
    }
}
#endif

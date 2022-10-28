//
//  InputBoxView.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/26.
//

import SwiftUI
import Combine

struct InputBoxView: View {
    // Dependcies
    @EnvironmentObject var appDIContainer: AppDIContainer
    @EnvironmentObject var calculatorState: CalculatorState
    // VM
    @StateObject private var viewModel = DefaultInputBoxViewModel()

    var body: some View {
        HStack {
            Spacer().frame(width: 10)
            Text("通貨:")
            Picker("ↂ", selection: $calculatorState.selectedCurrency) {
                ForEach(viewModel.getListofCurrency(), id: \.self) {
                    Text("\($0)").tag($0)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 30, height: 30)
            .onReceive([calculatorState.selectedCurrency].publisher.first()) { (base) in
                viewModel.loadCurrencyData(for: base)
            }
            TextField("0", text: $calculatorState.inputValue)
                .font(.system(size: 30))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)

            Spacer()
        }.onAppear {
            // method injection
            viewModel.inject(with: appDIContainer, with: calculatorState)
        }
    }
}
#if DEBUG
struct InputIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        InputBoxView().environmentObject(DevUtil.instance.calculatorStateFullStub)
            .environmentObject(AppDIContainer())
    }
}
#endif

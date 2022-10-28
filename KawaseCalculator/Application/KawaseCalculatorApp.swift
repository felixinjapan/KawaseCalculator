//
//  KawaseCalculatorApp.swift
//  為替(Kawase) Calculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import SwiftUI
// entry point for swiftui app
// provides all the functions to start the app
@main
struct KawaseCalculatorApp: App {

    // Initialize dependcies
    var calculatorState = CalculatorState()
    var appDIContainer = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(calculatorState)
                .environmentObject(appDIContainer)
                .navigationBarHidden(true)
        }
    }
}

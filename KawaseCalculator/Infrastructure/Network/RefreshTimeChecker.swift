//
//  RefreshTimeChecker.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/29.
//

import Foundation

// MARK: - RefreshTimeChecker

protocol RefreshTimeChecker {
    func resetTimer()
    func canCallAgain(now: Date, threshold: Int) -> Bool
} 

// MARK: - RefreshTimeChecker Implementation

final class DefaultAPIRefreshTimeChecker: RefreshTimeChecker {
    private var defaults = UserDefaults.standard
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    func resetTimer() {
        defaults.set(Date(), forKey: Constants.OpenExchangeRate.lastApiRun.rawValue)
    }
    
    func canCallAgain(now: Date, threshold: Int) -> Bool {
        if let from = defaults.value(forKey: Constants.OpenExchangeRate.lastApiRun.rawValue) as? Date {
            let diffComponents = Calendar.current.dateComponents([.minute], from: from, to: now)
            guard let minute = diffComponents.minute else { return false }
            return minute > threshold
        }
        // first run or time expired
        return true
    }
}

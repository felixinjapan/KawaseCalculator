//
//  RefreshTimeCheckerMock.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/03.
//

import Foundation

final class RefreshTimeCheckerCallAgainMock: RefreshTimeChecker {
    func resetTimer() { }

    func canCallAgain(now: Date, threshold: Int) -> Bool {
        return true
    }
}

final class RefreshTimeCheckerNotCallAgainMock: RefreshTimeChecker {
    func resetTimer() { }

    func canCallAgain(now: Date, threshold: Int) -> Bool {
        return false
    }
}

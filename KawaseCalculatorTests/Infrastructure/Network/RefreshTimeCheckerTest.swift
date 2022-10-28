//
//  RefreshTimeCheckerTest.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation
import XCTest

final class RefreshTimeCheckerTest: XCTestCase {

    func test_whenTimeHasPassedToCallAPI_shouldReturnTrue() {
        // given
        let suiteName = "whenTimeHasPassedToCallAPI"
        let keyName = Constants.OpenExchangeRate.lastApiRun.rawValue
        let oneHourAgo = Calendar.current.date( byAdding: .minute, value: -60, to: Date())
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.set(oneHourAgo, forKey: keyName)
        let sut = DefaultAPIRefreshTimeChecker(defaults: userDefaults)
        // when
        let result = sut.canCallAgain(now: .now, threshold: 30)

        // then
        XCTAssertTrue(result)
        userDefaults.removePersistentDomain(forName: suiteName)
    }

    func test_whenTimeHasNotPassedToCallAPI_shouldReturnFalse() {
        // given
        let suiteName = "whenTimeHasNotPassedToCallAPI"
        let keyName = Constants.OpenExchangeRate.lastApiRun.rawValue
        let twoMinsAgo = Calendar.current.date( byAdding: .minute, value: -2, to: Date())
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.set(twoMinsAgo, forKey: keyName)
        let sut = DefaultAPIRefreshTimeChecker(defaults: userDefaults)

        // when
        let result = sut.canCallAgain(now: .now, threshold: 30)

        // then
        XCTAssertFalse(result)
        userDefaults.removePersistentDomain(forName: suiteName)
    }

    func test_whenResetTimerCalled_shouldEraseFromUserDefault() {
        // given
        let suiteName = "whenResetTimerCalled"
        let keyName = Constants.OpenExchangeRate.lastApiRun.rawValue
        let userDefaults = UserDefaults(suiteName: suiteName)!
        let twoMinsAgo = Calendar.current.date( byAdding: .minute, value: -2, to: Date())
        userDefaults.set(twoMinsAgo, forKey: keyName)
        let sut = DefaultAPIRefreshTimeChecker(defaults: userDefaults)

        // when
        sut.resetTimer()
        guard let result = userDefaults.value(forKey: Constants.OpenExchangeRate.lastApiRun.rawValue) as? Date else { XCTFail(); return }

        // then
        XCTAssertNotEqual(result, twoMinsAgo)

        userDefaults.removePersistentDomain(forName: suiteName)
    }

    func test_whenLaunchAppForFirstTime_shouldReturnTrue() {
        // given
        let suiteName = "whenTimeHasNotPassedToCallAPI"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        let sut = DefaultAPIRefreshTimeChecker(defaults: userDefaults)

        // when
        let result = sut.canCallAgain(now: .now, threshold: 30)

        // then
        XCTAssertTrue(result)
        userDefaults.removePersistentDomain(forName: suiteName)
    }
}

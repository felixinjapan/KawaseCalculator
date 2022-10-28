//
//  ScrollUpToRefreshViewModelTest.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/02.
//

import XCTest

final class ScrollUpToRefreshViewModelTest: XCTestCase {

    @MainActor
    func test_whenScrollUpToBelowOffset_shouldNotTriggerRefresh() {
        // given
        let sut = DefaultScrollUpToRefreshViewModel()
        var offset = Constants.GeneralDouble.scrollOffsetConfig.rawValue
        sut.offset = offset
        sut.isRefreshing = false
        offset-=1
        // when
        // then
        XCTAssertFalse(sut.didUpdateOffset(offset))
    }

    @MainActor
    func test_whenScrollUpToAboveOffset_shouldTriggerRefresh() {
        // given
        let sut = DefaultScrollUpToRefreshViewModel()
        var offset = Constants.GeneralDouble.scrollOffsetConfig.rawValue
        sut.offset = offset
        offset+=1
        sut.isRefreshing = false

        // when
        // then
        XCTAssertTrue(sut.didUpdateOffset(offset))
    }

}

//
//  OERAPIRepositoryTest.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/03.
//

import XCTest

final class OERAPIRepositoryTest: XCTestCase {
    
    func test_whenRefreshIsAllowed_shouldUpdateCorrectState() {
        // given
        let expectation = self.expectation(description: "should call successfully")
        
        let timeCheckerCallAgainTrue = RefreshTimeCheckerCallAgainMock()
        let sut = OERAPIRepository(refreshTimeChecker: timeCheckerCallAgainTrue)
        
        let cancelBag = CancelBag()
        
        // when
        sut.getRatesByBase().sink(receiveCompletion: {
            if case .failure = $0 {
                XCTFail()
            }
        }, receiveValue: {_ in
            expectation.fulfill()
        }).store(in: cancelBag)
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_whenRefreshIsNotAllowed_shouldFallInFailure() {
        // given
        let expectation = self.expectation(description: "should fall in failure clause")

        let timeCheckerCallAgainTrue = RefreshTimeCheckerNotCallAgainMock()
        let sut = OERAPIRepository(refreshTimeChecker: timeCheckerCallAgainTrue)

        let cancelBag = CancelBag()

        // when
        sut.getRatesByBase().sink(receiveCompletion: {
            if case .failure = $0 {
                expectation.fulfill()
            }
        }, receiveValue: {_ in
            XCTFail()
        }).store(in: cancelBag)

        // then
        waitForExpectations(timeout: 5, handler: nil)
    }
}

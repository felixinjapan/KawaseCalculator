//
//  ScrollUp.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/26.
//

import SwiftUI

// MARK: - Scroll Up To Refresh ViewModel

protocol ScrollUpToRefreshViewModel: ObservableObject {
    var offset: CGFloat? { get }
    var initialOffset: CGFloat { get }
    var distanceToTriggerRefresh: CGFloat { get }
    var isRefreshing: Bool { get }
    func didUpdateOffset(_ value: CGFloat) -> Bool
}

// MARK: - ViewModel Implementation

final class DefaultScrollUpToRefreshViewModel: ScrollUpToRefreshViewModel {
    var offset: CGFloat?
    var initialOffset: CGFloat = 0.0
    let distanceToTriggerRefresh: CGFloat = CGFloat(Constants.GeneralDouble.scrollOffsetConfig.rawValue)
    @Published var isRefreshing: Bool = false
    
    @MainActor
    func didUpdateOffset(_ value: CGFloat) -> Bool {
        if offset != nil {
            self.offset = value
            let difference = value - initialOffset
            if difference > distanceToTriggerRefresh, !self.isRefreshing {
                self.isRefreshing = true
            } else if difference < distanceToTriggerRefresh {
                self.isRefreshing = false
            }
        } else {
            // Starting to scroll
            self.offset = value
            self.initialOffset = value
        }
        return self.isRefreshing
    }
}

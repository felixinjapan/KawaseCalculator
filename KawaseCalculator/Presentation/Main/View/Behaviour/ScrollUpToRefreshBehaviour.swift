//
//  ScrollUpToRefreshBehaviour.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/26.
//

import SwiftUI

// MARK: - Scroll Up To Refresh Behaviour

struct ScrollUpToRefreshBehaviour: View {
    var body: some View {
        GeometryReader { proxy in
            Rectangle().fill(Color.clear)
                .frame(width: 10, height: 10)
                .preference(key: ScrollOffsetPreference.self, value: proxy.frame(in: .global).origin.y)
        }
    }
}

// MARK: - Scroll Offset Preference

struct ScrollOffsetPreference: PreferenceKey {
    static var defaultValue: CGFloat = 0.0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

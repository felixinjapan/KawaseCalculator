//
//  CancelBag.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/02.
//

import Foundation
import Combine

final class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()

    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}

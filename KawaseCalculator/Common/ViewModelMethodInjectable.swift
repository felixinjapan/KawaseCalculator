//
//  MethodInjectable.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation

// might be improved to be a dynamic
protocol ViewModelMethodInjectable {
    associatedtype FirstDependency
    associatedtype SecondDependency
    func inject(with dependency: FirstDependency, with dependency: SecondDependency)
}

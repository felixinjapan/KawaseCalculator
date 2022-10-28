//
//  AppError.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import Foundation

enum AppError {
    enum NetworkError: Error {
        case error(statusCode: Int, data: Data?)
        case cancelled
        case tooManyApiCalls
        case generic(Error)
        case urlGeneration
        case noResponse
        case parsing(Error)
        case networkFailure(Error)
        case resolvedNetworkFailure(Error)
    }
    enum CoreData: Error {
        case noLocalDataExists
    }
}

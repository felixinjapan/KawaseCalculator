//
//  APIRequestManager.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import Foundation
import Combine

// MARK: - Open Exchange Rate APIRepository

final class OERAPIRepository {
    
    let apiConfiguration: APIConfiguration
    let refreshTimeChecker: RefreshTimeChecker
    var canCallApi: Bool {
        if refreshTimeChecker.canCallAgain(now: Date(), threshold: apiConfiguration.refreshIntervalInMinutes) {
            refreshTimeChecker.resetTimer()
            return true
        }
        return false
    }
    
    init(apiConfiguration: APIConfiguration = APIConfiguration(), refreshTimeChecker: RefreshTimeChecker = DefaultAPIRefreshTimeChecker()) {
        self.apiConfiguration = apiConfiguration
        self.refreshTimeChecker = refreshTimeChecker
    }
}

// MARK: - OERAPIRepository Implementation

extension OERAPIRepository: APIRepository {
    
    func getRatesByBase() -> AnyPublisher<CurrencyResponse, Error> {
        
        guard canCallApi else { return Fail(error: AppError.NetworkError.tooManyApiCalls).eraseToAnyPublisher() }
        
        let url = apiConfiguration.apiBaseURL.appendingPathComponent(apiConfiguration.pathGetLatest)
        
        // Construct a URL with components
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return Fail(error: AppError.NetworkError.urlGeneration).eraseToAnyPublisher()
        }
        
        components.scheme = apiConfiguration.scheme
        components.queryItems = [
            URLQueryItem(name: Constants.OpenExchangeRate.appIdParamKey.rawValue, value: apiConfiguration.appId)
        ]
        guard let compUrl = components.url else {
            return Fail(error: AppError.NetworkError.urlGeneration).eraseToAnyPublisher()
        }
        
        return execute(compUrl)
    }
}

//
//  Configuration.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import Foundation

// MARK: - APIConfiguration

final class APIConfiguration {
    let scheme = Constants.OpenExchangeRate.scheme.rawValue
    
    lazy var appId: String = {
        guard let appId = Bundle.main.object(forInfoDictionaryKey: Constants.InfoDictionaryKey.appId.rawValue) as? String else {
            fatalError("APP_ID must not be empty")
        }
        return appId.apiConfiguration_removeUrlBackslash()
    }()
    lazy var apiBaseURL: URL = {
        guard let stringUrl = Bundle.main.object(forInfoDictionaryKey: Constants.InfoDictionaryKey.apiBaseURL.rawValue) as? String else {
            fatalError("API_BASEURL must not be empty")
        }
        
        guard let apiBaseURL = URL(string: stringUrl.apiConfiguration_removeUrlBackslash()) else {
            fatalError("API_BASEURL parsing failed")
        }
        
        return apiBaseURL
    }()
    
    // latest.json endpoint
    lazy var pathGetLatest: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: Constants.InfoDictionaryKey.getLatestExchangeRatePath.rawValue) as? String else {
            fatalError("GET_LATEST_EXCHANGE_RATE_PATH not found")
        }
        return apiBaseURL.apiConfiguration_removeUrlBackslash()
    }()
    
    lazy var refreshIntervalInMinutes: Int = {
        guard let strInterval = Bundle.main.object(forInfoDictionaryKey: Constants.InfoDictionaryKey.refreshIntervalInMinutes.rawValue) as? String else {
            fatalError("RefreshIntervalInMinutes not found")
        }

        guard let interval = Int(strInterval) else {
            fatalError("RefreshIntervalInMinutes must be an integer")
        }

        return interval
    }()
    
    lazy var apiRetryCount: Int = {
        guard let strValue = Bundle.main.object(forInfoDictionaryKey: Constants.InfoDictionaryKey.apiRetryCount.rawValue) as? String else {
            fatalError("apiRetryCount not found")
        }
        guard let apiRetryCount = Int(strValue) else {
            fatalError("apiRetryCount must be an integer")
        }
        return apiRetryCount
    }()
    
    lazy var apiTimeoutInSec: Double = {
        guard let strValue = Bundle.main.object(forInfoDictionaryKey: Constants.InfoDictionaryKey.apiTimeoutInSec.rawValue) as? String else {
            fatalError("apiTimeoutInSec not found")
        }

        guard let apiTimeoutInSec = Double(strValue) else {
            fatalError("apiTimeoutInSec must be an integer")
        }

        return apiTimeoutInSec
    }()
    
    lazy var urlSessionConfig: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = self.apiTimeoutInSec
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()
}

// MARK: - String Extension

extension String {
    
    func apiConfiguration_removeUrlBackslash() -> String {
        return self.replacingOccurrences(of: "\"", with: Constants.General.emptyString.rawValue)
    }
}

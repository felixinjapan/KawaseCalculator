//
//  Constants.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import Foundation

enum Constants {
    enum OpenExchangeRate: String {
        case scheme = "https"
        case appIdParamKey = "app_id"
        case lastApiRun = "lastApiRun"
    }
    enum Coredata: String {
        case nameDataModel = "CurrencyContainer"
        case currencyEntity = "CurrencyEntity"
        case baseCurrencyEntity = "BaseCurrencyEntity"
    }
    enum InfoDictionaryKey: String {
        case appId = "AppId"
        case apiBaseURL = "ApiBaseURL"
        case getLatestExchangeRatePath = "GetLatestExchangeRatePath"
        case refreshIntervalInMinutes = "RefreshIntervalInMinutes"
        case apiRetryCount = "ApiRetryCount"
        case apiTimeoutInSec = "ApiTimeoutInSec"
    }
    enum General: String {
        case unknownCurrency = "unknown"
        case wrongAmount = " - "
        case defaultCurrency = "USD"
        case emptyString = ""
    }
    enum Logging: String {
        case subsystem = "jp.co.felixinjapan.KawaseCalculator"
        case viewModel = "viewModel"
        case useCases = "useCases"
        case network = "network"
        case view = "view"
        case coredata = "coredata"
    }
    enum GeneralDouble: Double {
        case scrollOffsetConfig = 100.0
    }
    enum UnitTest: String {
        case testCurrency = "USD"
    }
    enum UnitTestDouble: Double {
        case testRatio = 1.1
    }
}

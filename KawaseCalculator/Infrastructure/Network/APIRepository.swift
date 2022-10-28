//
//  APIRepository.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/01.
//

import Foundation
import Combine

// MARK: - API Respository
protocol APIRepository {
    
    var apiConfiguration: APIConfiguration { get }

    func getRatesByBase() -> AnyPublisher<CurrencyResponse, Error>
}

extension APIRepository {
    func execute<Response: Decodable>(_ url: URL) -> AnyPublisher<Response, Error> {
        // make a request
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(apiConfiguration.apiRetryCount)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

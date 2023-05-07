//
//  ChartNetworkService.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 05.05.2023.
//

import Foundation

protocol ChartNetworkServiceProtocol {
    func fetchCriptoPrices(for coin: String) async throws -> CryptoPricesAPI?
}

class ChartNetworkService: ChartNetworkServiceProtocol {
    
    var apiModelCreator: ApiModelCreatorServiceProtocol? = ApiModelCreatorService()
    
    func fetchCriptoPrices(for coin: String) async throws -> CryptoPricesAPI? {
        let urlString = "https://api.coincap.io/v2/assets/\(coin.lowercased())/history?interval=d1"
        guard let url = URL(string: urlString) else { throw Errors.badUrl }
        let session = URLSession.init(configuration: .default)
        let response = try await session.data(from: url)
        let cryptoPricesApi = apiModelCreator?.createCriptoPricesApi(from: response.0)
        return cryptoPricesApi
    }
    
    
}

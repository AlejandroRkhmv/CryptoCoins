//
//  NetworkService.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchCriptoList() async throws -> CryptoListAPI?
}

class NetworkService: NetworkServiceProtocol {
    
    var apiModelCreator: ApiModelCreatorServiceProtocol? = ApiModelCreatorService()
    
    func fetchCriptoList() async throws -> CryptoListAPI? {
        let urlString = "https://api.coincap.io/v2/assets"
        guard let url = URL(string: urlString) else { throw Errors.badUrl }
        let session = URLSession.init(configuration: .default)
        let response = try await session.data(from: url)
        let cryptoListApi = apiModelCreator?.createCryptoListApi(from: response.0)
        return cryptoListApi
    }
}

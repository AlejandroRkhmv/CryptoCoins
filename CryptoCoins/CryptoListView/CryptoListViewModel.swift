//
//  CriptoListViewModel.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import Foundation

protocol CriptoListViewModelProtocol: ObservableObject {
    var cryptos: [Crypto]? { get set }
    
    func getCrypto() async throws 
}

class CryptoListViewModel: CriptoListViewModelProtocol {
    
    private var networkService: NetworkServiceProtocol?
    private var coinCreatorServise: CoinCreatorServiceProtocol?
    
    init(networkService: NetworkServiceProtocol? = NetworkService(), coinCreatorServise: CoinCreatorServiceProtocol? = CoinCreatorService()) {
        self.networkService = networkService
        self.coinCreatorServise = coinCreatorServise
    }
    
    @Published var cryptos: [Crypto]?
    
    @MainActor
    func getCrypto() async throws {
        do {
            guard let cryptoListApi = try await networkService?.fetchCriptoList() else { return }
            self.cryptos = coinCreatorServise?.createCrypto(cryptoListAPI: cryptoListApi)
        } catch {
            print(Errors.errorFromCryptoListViewModel)
        }
    }
}

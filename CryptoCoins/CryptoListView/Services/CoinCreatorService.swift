//
//  CoinCreatorService.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import Foundation

//enum Keys: String {
//    case symbol
//    case name
//    case priceUsd
//}

protocol CoinCreatorServiceProtocol {
    func createCrypto(cryptoListAPI: CryptoListAPI) -> [Crypto]
}

class CoinCreatorService: CoinCreatorServiceProtocol {
    
    func createCrypto(cryptoListAPI: CryptoListAPI) -> [Crypto] {
        var cryptos: [Crypto] = []
        for coin in cryptoListAPI.data {
            guard let name = coin.name, let symbol = coin.symbol, let price = coin.priceUsd, let changePercent = coin.changePercent24Hr else { return [] }
            let crypto = Crypto(name: name, symbol: symbol, price: price, changePersent: changePercent)
            cryptos.append(crypto)
        }
        return cryptos
    }
}




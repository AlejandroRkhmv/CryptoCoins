//
//  CryptoListModel.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import Foundation

// MARK: - CryptoListAPI
struct CryptoListAPI: Codable {
    let data: [CryptoCoin]
    let timestamp: Int
}

struct CryptoCoin: Codable {
    let id: String?
    let rank: String?
    let symbol: String?
    let name: String?
    let supply: String?
    let maxSupply: String?
    let marketCapUsd: String?
    let volumeUsd24Hr: String?
    let priceUsd: String?
    let changePercent24Hr: String?
    let vwap24Hr: String?
    let explorer: String?
}

class Crypto: Identifiable {
    let name: String
    let symbol: String
    let price: String
    let changePersent: String
    
    init(name: String, symbol: String, price: String, changePersent: String) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.changePersent = changePersent
    }
}

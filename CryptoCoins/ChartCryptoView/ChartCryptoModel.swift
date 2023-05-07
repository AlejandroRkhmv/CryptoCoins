//
//  ChartCryptoModel.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 05.05.2023.
//

import Foundation

// MARK: - CryptoPricesAPI
struct CryptoPricesAPI: Codable {
    let data: [Coin]
    let timestamp: Int
}

struct Coin: Codable {
    let priceUsd: String?
    let time: Int?
    let date: String?
}

class CryptoPrice {
    let price: Double
    let date: String
    
    init(price: Double, date: String) {
        self.price = price
        self.date = date
    }
}

//
//  PricesArrayCreatorService.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 05.05.2023.
//

import Foundation

protocol PricesArrayCreatorServiceProtocol {
    func createPrices(cryptoPricesApi: CryptoPricesAPI) -> [CryptoPrice]
}

class PricesArrayCreatorService: PricesArrayCreatorServiceProtocol {
    
    func createPrices(cryptoPricesApi: CryptoPricesAPI) -> [CryptoPrice] {
        var cryptoPrices: [CryptoPrice] = []
        for coin in cryptoPricesApi.data {
            guard let priceString = coin.priceUsd,
                  let price = Double(priceString),
                  let date = coin.date else { return [] }
            let cryptoPrice = CryptoPrice(price: price, date: createNeedDate(string: date))
            cryptoPrices.append(cryptoPrice)
        }
        return cryptoPrices
    }
    
    private func createNeedDate(string: String) -> String {
        let index = string.index(string.startIndex, offsetBy: 10)
        let dateSubString = string.prefix(upTo: index)
        let dateComponents = dateSubString.components(separatedBy: "-")
        return dateComponents[2] + "." + dateComponents[1] + "." + dateComponents[0]
    }
}

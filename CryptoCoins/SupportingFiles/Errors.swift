//
//  Errors.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import Foundation

enum Errors: Error {
    case badUrl
    case errorCreateCryptoListAPI
    case errorFromCryptoListViewModel
    case errorGetCryptosFromView
    case errorCreateCryptoPricesArray
    case errorFromChartCryptoViewModel
    case errorGetCryptoPricesFromView
    case errorLoadCoinIcon
}

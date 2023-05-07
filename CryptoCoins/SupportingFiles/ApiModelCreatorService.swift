//
//  ApiModelCreator.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import Foundation

protocol ApiModelCreatorServiceProtocol {
    func createCryptoListApi(from data: Data) -> CryptoListAPI?
    func createCriptoPricesApi(from data: Data) -> CryptoPricesAPI?
}

class ApiModelCreatorService: ApiModelCreatorServiceProtocol {
    let decoder = JSONDecoder()
    
    func createCryptoListApi(from data: Data) -> CryptoListAPI? {
        do {
            let cryptoListApi = try decoder.decode(CryptoListAPI.self, from: data)
            return cryptoListApi
        } catch {
            print(Errors.errorCreateCryptoListAPI)
        }
        return nil
    }
    
    func createCriptoPricesApi(from data: Data) -> CryptoPricesAPI? {
        do {
            let cryptoPricesApi = try decoder.decode(CryptoPricesAPI.self, from: data)
            return cryptoPricesApi
        } catch {
            print(Errors.errorCreateCryptoPricesArray)
        }
        return nil
    }
}

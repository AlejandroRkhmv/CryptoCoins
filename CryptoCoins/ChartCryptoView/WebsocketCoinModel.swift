//
//  WebsocketCoinModel.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 05.05.2023.
//

import Foundation

// MARK: - Coins

struct CoinName: Decodable {
    var name: String
    
    private struct DynamicCodingKeys: CodingKey {

           // Use for string-keyed dictionary
           var stringValue: String
           init?(stringValue: String) {
               self.stringValue = stringValue
           }

           // Use for integer-keyed dictionary
           var intValue: Int?
           init?(intValue: Int) {
               // We are not using this, thus just return nil
               return nil
           }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let decodedObject = try? container.decode(String.self, forKey: DynamicCodingKeys(stringValue: container.allKeys.first?.stringValue ?? "")!)
        name = decodedObject ?? ""
    }
}

struct Coins: Codable {
    let bitcoin: String
}

//
//  WebsocketService.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 05.05.2023.
//

import SwiftUI
import Combine
import Foundation

protocol WebSocketServiceProtocol {
    func connect(coinName: String, completion: @escaping (Double) -> Void)
    func close()
}

class WebSocketService: WebSocketServiceProtocol {
    
    private let urlSession = URLSession(configuration: .default)
    private var webSocket: URLSessionWebSocketTask?
    
    func connect(coinName: String, completion: @escaping (Double) -> Void) {
        close()
        guard let url = URL(string: "wss://ws.coincap.io/prices?assets=\(coinName)") else { return }
        webSocket = urlSession.webSocketTask(with: url)
        webSocket?.resume()
        ping()
        receive(completion: completion)
    }
    
    private func receive(completion: @escaping (Double) -> Void) {
        webSocket?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got data: \(data)")
                case .string(let string):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CoinName.self, from: Data(string.utf8))
                        DispatchQueue.main.async {
                            guard let price = Double(result.name) else { return }
                            print(price)
                            completion(price)
                        }
                    } catch  {
                        print("error is \(error.localizedDescription)")
                    }
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Receive error: \(error.localizedDescription)")
            }
            self.receive(completion: completion)
        }
        
    }
    
    private func ping() {
        webSocket?.sendPing { error in
            guard let error = error else { return }
            print("Ping error: \(error.localizedDescription)")
        }
    }

    func close() {
        webSocket?.cancel(with: .goingAway, reason: "Demo endid".data(using: .utf8))
    }
}

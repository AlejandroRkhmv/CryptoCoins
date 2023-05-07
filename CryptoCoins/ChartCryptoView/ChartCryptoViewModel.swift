//
//  ChartCryptoViewModel.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 05.05.2023.
//

import Foundation

protocol ChartCryptoViewModelProtocol: ObservableObject {
    var prices: [Double]? { get }
    var dates: [String]? { get }
    var currentPrice: Double? { get }
    
    func getPrices(for coinName: String) async throws
    func getCurrentPrice(for cryptoName: String)
    func close()
}

class ChartCryptoViewModel: ChartCryptoViewModelProtocol {
    var service: WebSocketServiceProtocol = WebSocketService()
    private var chartNetworkService: ChartNetworkServiceProtocol?
    private var pricesArrayCreator: PricesArrayCreatorServiceProtocol?
    
    init(chartNetworkService: ChartNetworkServiceProtocol? = ChartNetworkService(), pricesArrayCreator: PricesArrayCreatorServiceProtocol? = PricesArrayCreatorService()) {
        self.chartNetworkService = chartNetworkService
        self.pricesArrayCreator = pricesArrayCreator
    }
    
    @Published var prices: [Double]?
    @Published var dates: [String]?
    @Published var currentPrice: Double?
    
    @MainActor
    func getPrices(for coinName: String) async throws {
        do {
            guard let cryptoPricesApi = try await chartNetworkService?.fetchCriptoPrices(for: coinName),
                  let cryptoPrices = pricesArrayCreator?.createPrices(cryptoPricesApi: cryptoPricesApi) else { return }
            self.prices = setPricesArray(from: cryptoPrices)
            self.dates = setDates(from: cryptoPrices)
        } catch {
            print(Errors.errorFromChartCryptoViewModel)
        }
    }
    
    private func setPricesArray(from cryptos: [CryptoPrice]) -> [Double] {
        var tempPriceArray: [Double] = []
        for crypto in cryptos {
            tempPriceArray.append(crypto.price)
        }
        return tempPriceArray
    }
    
    private func setDates(from cryptoPrices: [CryptoPrice]) -> [String] {
        var tempDates = [String]()
        tempDates.append(cryptoPrices.first?.date ?? "")
        tempDates.append(cryptoPrices.last?.date ?? "")
        return tempDates
    }
    
    func getCurrentPrice(for cryptoName: String) {
        service.connect(coinName: cryptoName) { price in
            self.currentPrice = price
        }
    }
    
    func close() {
        service.close()
    }
}

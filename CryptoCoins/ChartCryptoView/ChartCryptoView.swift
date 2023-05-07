//
//  ChartCryptoView.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 05.05.2023.
//

import SwiftUI

struct ChartCryptoView<Model>: View where Model: ChartCryptoViewModelProtocol {
    
    @EnvironmentObject private var navigationState: NavigationState
    @StateObject var chartCryptoViewModel: Model
    var cryptoName: String
    var symbol: String
    
    init(chartCryptoViewModel: Model, cryptoName: String, symbol: String) {
        _chartCryptoViewModel = StateObject(wrappedValue: chartCryptoViewModel)
        self.cryptoName = cryptoName
        self.symbol = symbol
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(cryptoName)
                    .font(.custom("Courier", size: 40))
                    .foregroundColor(Color(Colors.text.rawValue))
                    .shadow(color: .purple, radius: 1, x: 0, y: 0)
                ChartView(chartCryptoViewModel: chartCryptoViewModel)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.5)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 3)
                Spacer()
                Text("$" + String(format: "%.4f", chartCryptoViewModel.currentPrice ?? 0.0))
                    .font(.custom("Courier", size: 30))
                    .foregroundColor(Color(Colors.text.rawValue))
                    .shadow(color: .purple, radius: 1, x: 0, y: 0)
            }
            .onAppear {
                fetchData(for: cryptoName)
                chartCryptoViewModel.getCurrentPrice(for: cryptoName.lowercased())
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        chartCryptoViewModel.close()
                        navigationState.dismiss()
                    } label: {
                        Text("Back")
                            .font(.custom("Courier", size: 20))
                            .foregroundColor(Color(Colors.text.rawValue))
                            .shadow(color: .purple, radius: 1, x: 0, y: 0)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text(symbol)
                            .font(.custom("Courier", size: 30))
                            .foregroundColor(Color(Colors.text.rawValue))
                            .shadow(color: .purple, radius: 1, x: 0, y: 0)
                        CoinImage(symbol: symbol.lowercased())
                    }
                }
        }
        }
    }
    
    
    // MARK: - functions
    func fetchData(for cryptoName: String) {
        Task {
            do {
                try await chartCryptoViewModel.getPrices(for: cryptoName)
            }
            catch {
                print(Errors.errorGetCryptoPricesFromView)
            }
        }
    }
}

struct ChartView: View {
    var chartCryptoViewModel: any ChartCryptoViewModelProtocol
    let prices: [Double]
    let minYPosition: Double
    let maxYPosition: Double
    let chartColor: Color
    @State private var isShowChart = false
//    @State private var price = 0.0
//    @State private var isPriceShow = false
    
    init(chartCryptoViewModel: any ChartCryptoViewModelProtocol) {
        self.chartCryptoViewModel = chartCryptoViewModel
        self.prices = chartCryptoViewModel.prices ?? []
        minYPosition = prices.min() ?? 0
        maxYPosition = prices.max() ?? 0
        let priceChange = (prices.last ?? 0) - (prices.first ?? 0)
        self.chartColor = priceChange > 0 ? Color.green : Color.red
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    for index in prices.indices {
                        let xPosition = geometry.size.width / CGFloat(prices.count) * CGFloat(index + 1)
                        let yAxis = maxYPosition - minYPosition
                        let yPosition = (1 - CGFloat((prices[index] - minYPosition) / yAxis)) * geometry.size.height
                        if index == 0 {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        }
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
                .trim(from: 0, to: isShowChart ? 1 : 0)
                .stroke(chartColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .background {
                    chartBackground
                }
                .overlay(minMaxMiddlePrices, alignment: .leading)
                .onAppear {
                    withAnimation(.linear(duration: 10)) {
                        isShowChart.toggle()
                    }
                }
                HStack {
                    Text(chartCryptoViewModel.dates?[0] ?? "")
                    Spacer()
                    Text(chartCryptoViewModel.dates?[1] ?? "")
                }
                .padding(.horizontal, 10)
                .position(x: geometry.size.width / 2, y: geometry.size.height * 1.1)
            }
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
                .overlay(Color.gray)
            Spacer()
            Divider()
                .overlay(Color.gray)
            Spacer()
            Divider()
                .overlay(Color.gray)
        }
    }
    
    private var minMaxMiddlePrices: some View {
        VStack(alignment: .leading) {
            Text(String(format: "$%.1f", maxYPosition))
            Spacer()
            let middlePrice = (maxYPosition + minYPosition) / 2
            Text(String(format: "$%.1f", middlePrice))
            Spacer()
            Text(String(format: "$%.1f", minYPosition))
        }
        .foregroundColor(.gray)
        .shadow(color: .purple, radius: 1, x: 0, y: 0)
    }
    
}

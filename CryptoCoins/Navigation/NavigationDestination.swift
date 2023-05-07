//
//  NavigationDestination.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import SwiftUI

enum NavigationDestination: Hashable {
    case cryptoListView
    case chartCryptoView(cryptoName: String, symbol: String)
}

extension View {
    func withNavigationDestination() -> some View {
        self.navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .cryptoListView:
                let viewModel = CryptoListViewModel()
                CryptoListView(cryptoListViewModel: viewModel)
            case .chartCryptoView(let cryptoName, let symbol):
                let chartViewModel = ChartCryptoViewModel()
                ChartCryptoView(chartCryptoViewModel: chartViewModel, cryptoName: cryptoName, symbol: symbol)
            }
        }
    }
}

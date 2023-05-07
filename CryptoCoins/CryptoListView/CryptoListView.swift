//
//  CryptoListView.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import SwiftUI

struct CryptoListView<Model>: View where Model: CriptoListViewModelProtocol {
    @EnvironmentObject private var navigationState: NavigationState
    @StateObject var cryptoListViewModel: Model
    @State private var isInfoVisible = false
    
    init(cryptoListViewModel: Model) {
        _cryptoListViewModel = StateObject(wrappedValue: cryptoListViewModel)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("coin")
                    Spacer()
                    Text("price")
                }
                .padding(.horizontal)
                List(cryptoListViewModel.cryptos ?? []) {coin in
                    Button {
                        navigationState.navigate(to: .chartCryptoView(cryptoName: coin.name, symbol: coin.symbol))
                    } label: {
                        HStack {
                            CoinImage(symbol: coin.symbol.lowercased())
                            VStack(alignment: .leading) {
                                Text(coin.name)
                                    .font(.custom("Courier", size: 15))
                               
                                    Text(coin.symbol)
                                        .font(.custom("Courier", size: 30))
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                if let price = Double(coin.price) {
                                    Text(String(format: "$%.4f", price))
                                        .font(.custom("Courier", size: 15))
                                }
                                HStack {
                                    Image(systemName: coin.changePersent.hasPrefix("-") ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                    if let persent = Double(coin.changePersent) {
                                        Text(String(format: "%.2f", abs(persent)))
                                            .font(.custom("Courier", size: 15))
                                    }
                                }
                                .foregroundColor(coin.changePersent.hasPrefix("-") ? .red : .green)
                            }
                        }
                        .foregroundColor(Color(Colors.text.rawValue))
                        .shadow(color: .purple, radius: 1, x: 0, y: 0)
                    }
                }
                .listStyle(.inset)
                .scrollIndicators(ScrollIndicatorVisibility.hidden)
            }
            .padding(.top, 30)
            .padding(.horizontal, 10)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.linear(duration: 2)) {
                            isInfoVisible.toggle()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(Colors.background.rawValue))
                                .shadow(color: .purple, radius: 1, x: 0, y: 0)
                            Image(systemName: "info")
                                .foregroundColor(Color(Colors.text.rawValue))
                                .shadow(color: .purple, radius: 1, x: 0, y: 0)
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Crypto")
                        .font(.custom("Courier", size: 30))
                        .foregroundColor(Color(Colors.text.rawValue))
                        .shadow(color: .purple, radius: 1, x: 0, y: 0)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        cryptoListViewModel.cryptos?.removeAll()
                        fetchData()
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(Colors.background.rawValue))
                                .shadow(color: .purple, radius: 1, x: 0, y: 0)
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(Color(Colors.text.rawValue))
                                .shadow(color: .purple, radius: 1, x: 0, y: 0)
                        }
                    }
                }
            }
            .onAppear {
                fetchData()
        }
            InfoView()
                .opacity(isInfoVisible ? 1 : 0)
                .onTapGesture {
                    withAnimation(.linear(duration: 2)) {
                        isInfoVisible.toggle()
                    }
                }
        }
    }
    
    // MARK: - functions
    func fetchData() {
        Task {
            do {
                try await cryptoListViewModel.getCrypto()
            }
            catch {
                print(Errors.errorGetCryptosFromView)
            }
        }
    }
}

struct InfoView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(Colors.background.rawValue))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("You must remember that")
                Text("investing in cryptocurrency")
                Text("guarantees a 100% loss")
                Text("of your money")
            }
                .font(.custom("Courier", size: 25))
                .foregroundColor(Color(Colors.text.rawValue))
                .shadow(color: .purple, radius: 1, x: 0, y: 0)
                .padding()
        }
    }
}

struct CryptoList_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CryptoListViewModel()
        CryptoListView(cryptoListViewModel: viewModel)
    }
}

struct CoinImage: View {
    var symbol: String
    var body: some View {
        AsyncImage(url: URL(string: "https://coinicons-api.vercel.app/api/icon/\(symbol)")) { result in
            switch result {
            case .empty:
                ProgressView()
                    .tint(Color.gray)
                    .shadow(color: .purple, radius: 1, x: 0, y: 0)
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle()).frame(width: 40, height: 40)
            case .failure(_):
                Image(systemName: "c.circle.fill")
            @unknown default:
                fatalError()
            }
        }
    }
}


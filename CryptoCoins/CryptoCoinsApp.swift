//
//  CryptoCoinsApp.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import SwiftUI

@main
struct CryptoCoinsApp: App {
    let navigationState = NavigationState()
    var body: some Scene {
        WindowGroup {
            ContainerView().environmentObject(navigationState)
        }
    }
}

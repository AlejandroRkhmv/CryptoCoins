//
//  ContainerView.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import SwiftUI

struct ContainerView: View {
    
    @EnvironmentObject private var navigationState: NavigationState
    
    var body: some View {
        NavigationStack(path: $navigationState.path) {
            StartScreenView()
                .withNavigationDestination()
        }
    }
}

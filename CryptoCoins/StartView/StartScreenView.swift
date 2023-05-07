//
//  StartScreenView.swift
//  CryptoCoins
//
//  Created by Александр Рахимов on 27.04.2023.
//

import SwiftUI

struct StartScreenView: View {
    
    var body: some View {
        CryptoPresentView()
    }
}

struct CryptoPresentView: View {
    @EnvironmentObject private var navigationState: NavigationState
    @State var isVisible = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    var body: some View {
        GeometryReader { geometry in
            
            let widthScreen = geometry.frame(in: .local).width
            let heightScreen = geometry.frame(in: .local).height
            
            ZStack {
                Color(Colors.background.rawValue).ignoresSafeArea()
                Group {
                    Text("C")
                        .offset(x: -widthScreen * 0.4, y: heightScreen * 0.2)
                        .opacity(isVisible >= 1 ? 0.75 : 0.0)
                    Text("RY")
                        .offset(x: -widthScreen * 0.15, y: -heightScreen * 0.1)
                        .opacity(isVisible >= 3 ? 0.8 : 0.0)
                    Text("P")
                        .offset(x: widthScreen * 0.1, y: heightScreen * 0.1)
                        .opacity(isVisible >= 5 ? 0.85 : 0.0)
                    Text("TO")
                        .offset(x: widthScreen * 0.35, y: -heightScreen * 0.25)
                        .opacity(isVisible >= 7 ? 0.9 : 0.0)
                    Text("THE")
                        .offset(x: widthScreen * 0.35, y: -heightScreen * 0.3)
                        .opacity(isVisible >= 8 ? 0.95 : 0.0)
                    Text("MOON")
                        .offset(x: widthScreen * 0.35, y: -heightScreen * 0.35)
                        .opacity(isVisible >= 9 ? 1.0 : 0.0)
                    CRYLine(widthScreen: widthScreen, heightScreen: heightScreen)
                        .trim(from: 0.0, to: isVisible >= 2 ? 1.0 : 0.0)
                        .stroke(Color(Colors.text.rawValue), lineWidth: 3)
                    RYPLine(widthScreen: widthScreen, heightScreen: heightScreen)
                        .trim(from: 0.0, to: isVisible >= 4 ? 1.0 : 0.0)
                        .stroke(Color(Colors.text.rawValue), lineWidth: 3)
                    PTOLine(widthScreen: widthScreen, heightScreen: heightScreen)
                        .trim(from: 0.0, to: isVisible >= 6 ? 1.0 : 0.0)
                        .stroke(Color(Colors.text.rawValue), lineWidth: 3)
                }
                .foregroundColor(Color(Colors.text.rawValue))
                .shadow(color: .purple, radius: 1, x: 0, y: 0)
                .font(.custom("Courier", size: 30))
            }
            .onReceive(timer) { _ in
                withAnimation(.easeOut(duration: 3)) {
                    isVisible += 1
                    switch isVisible {
                    case 15:
                        navigationState.navigate(to: .cryptoListView)
                        self.timer.upstream.connect().cancel()
                    default: break
                    }
                }
            }
        }
    }
}

struct CRYLine: Shape {
    
    var widthScreen: CGFloat
    var heightScreen: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + widthScreen * 0.15, y: rect.midY + heightScreen * 0.15))
        path.addLine(to: CGPoint(x: rect.midX - widthScreen * 0.2, y: rect.midY - heightScreen * 0.05))
        return path
    }
}

struct RYPLine: Shape {
    
    var widthScreen: CGFloat
    var heightScreen: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX - widthScreen * 0.1, y: rect.midY - heightScreen * 0.05))
        path.addLine(to: CGPoint(x: rect.midX + widthScreen * 0.05, y: rect.midY + heightScreen * 0.05))
        return path
    }
}

struct PTOLine: Shape {
    
    var widthScreen: CGFloat
    var heightScreen: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX + widthScreen * 0.15, y: rect.midY + heightScreen * 0.05))
        path.addLine(to: CGPoint(x: rect.midX + widthScreen * 0.35, y: rect.midY - heightScreen * 0.2))
        return path
    }
}

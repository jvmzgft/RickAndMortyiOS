//
//  SplashView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var viewModel: SplashViewModel
    @State private var fadeOut = false
    
    var body: some View {
        LottieView(animationName: viewModel.splashLottie) {
            withAnimation(.easeOut(duration: 1.0)) {
                fadeOut = true
            }
            Task {
                try? await Task.sleep(for: .seconds(1))
                await MainActor.run { viewModel.goToTabBar() }
            }
        }
        .opacity(fadeOut ? 0 : 1)
        .padding()
    }
}

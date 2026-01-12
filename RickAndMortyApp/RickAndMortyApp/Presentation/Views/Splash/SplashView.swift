//
//  SplashView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: SplashViewModel
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

import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let contentMode: UIView.ContentMode
    let onFinished: (() -> Void)?

    init(
        animationName: String,
        loopMode: LottieLoopMode = .playOnce,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        onFinished: (() -> Void)? = nil
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.contentMode = contentMode
        self.onFinished = onFinished
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = loopMode
        animationView.contentMode = contentMode
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        animationView.play { finished in
            if finished {
                DispatchQueue.main.async {
                    onFinished?()
                }
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Not needed yet
    }
}

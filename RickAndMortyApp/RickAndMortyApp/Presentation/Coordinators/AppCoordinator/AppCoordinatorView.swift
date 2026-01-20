//
//  AppCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

struct AppCoordinatorView: View {
    @State var coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator = AppCoordinator()) {
        _coordinator = State(wrappedValue: coordinator)
    }
    
    var body: some View {
        switch coordinator.currentScreen {
        case .splash:
            splashView()
        case .tabView:
            tabView()
        }
    }
    
    @ViewBuilder
    private func splashView() -> some View {
        SplashView(viewModel: .init(splashLottie: "rick.json", coordinator: coordinator))
    }
    
    @ViewBuilder
    private func tabView() -> some View {
        TabBarCoordinatorView(coordinator: coordinator.tabBarCoordinator ?? TabBarCoordinator(parentCoordinator: coordinator))
    }
}

//
//  SplashViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

class SplashViewModel: ViewModel<AppCoordinator> {
    let splashLottie: String
    
    init(splashLottie: String, coordinator: Coordinator) {
        self.splashLottie = splashLottie
        super.init(coordinator: coordinator)
    }
    
    @MainActor
    func goToTabBar() {
        getCoordinator()?.navigateToTabBar()
    }
}

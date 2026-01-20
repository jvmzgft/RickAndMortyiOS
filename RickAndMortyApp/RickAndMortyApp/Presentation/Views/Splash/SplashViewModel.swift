//
//  SplashViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Observation

@Observable
class SplashViewModel: ViewModel<AppCoordinatorProtocol> {
    let splashLottie: String
    
    init(splashLottie: String, coordinator: NavigatingCoordinator) {
        self.splashLottie = splashLottie
        super.init(coordinator: coordinator)
    }
    
    func goToTabBar() {
        getCoordinator()?.navigateToTabBar()
    }
}

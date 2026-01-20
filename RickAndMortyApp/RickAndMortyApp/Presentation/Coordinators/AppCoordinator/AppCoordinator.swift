//
//  AppCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Observation

protocol AppCoordinatorProtocol: AnyObject {
    func navigateToTabBar()
}

@Observable
class AppCoordinator: NavigatingCoordinator, AppCoordinatorProtocol {
    enum AppCoordinatorScreen {
        case splash
        case tabView
    }
    
    var currentScreen: AppCoordinatorScreen = .splash
        
    @MainActor
    func navigateToTabBar() {
        currentScreen = .tabView
    }

}

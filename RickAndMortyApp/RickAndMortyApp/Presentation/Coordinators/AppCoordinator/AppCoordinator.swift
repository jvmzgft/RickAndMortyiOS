//
//  AppCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Combine

protocol AppCoordinatorDelegate: AnyObject {
    func navigateToTabBar()
}

class AppCoordinator: Coordinator, AppCoordinatorDelegate {
    enum AppCoordinatorScreen {
        case splash
        case tabView
    }
    
    @Published var currentScreen: AppCoordinatorScreen = .splash
        
    @MainActor
    func navigateToTabBar() {
        currentScreen = .tabView
    }

}

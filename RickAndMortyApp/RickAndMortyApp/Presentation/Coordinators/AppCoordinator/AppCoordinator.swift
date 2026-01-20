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
class AppCoordinator: Coordinator, AppCoordinatorProtocol {
    enum AppCoordinatorScreen {
        case splash
        case tabView
    }
    
    var currentScreen: AppCoordinatorScreen = .splash
    var tabBarCoordinator: TabBarCoordinator?
    
    init() {
        super.init()
        tabBarCoordinator = .init(parentCoordinator: self)
    }
    
    @MainActor
    func navigateToTabBar() {
        currentScreen = .tabView
    }

    @MainActor
    func handleShortcut(destination: NavigationDestionation) {
        currentScreen = .tabView
        tabBarCoordinator?.handleDeeplink(destination: destination)
    }

}

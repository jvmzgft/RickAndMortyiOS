//
//  NavigatingCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Foundation

protocol NavigatingProtocol: AnyObject {
    var path: AppPath { get set }
    func navigateTo(_ spec: AppViewSpec)
    func handleDeeplink(destination: NavigationDestionation)
    func clearPath()
}

open class NavigatingCoordinator: NavigatingProtocol {
    var path: AppPath = AppPath()
    weak var parentCoordinator: NavigatingCoordinator?

    init(parentCoordinator: NavigatingCoordinator? = nil) {
        self.parentCoordinator = parentCoordinator
    }
    
    func navigateTo(_ spec: AppViewSpec) {
        path.push(spec)
    }
    
    func clearPath() {
        path.popToRoot()
    }

    func handleDeeplink(destination: NavigationDestionation) {
        print("Override handleDeeplink in a subclass.")
    }
}

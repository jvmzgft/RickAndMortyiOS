//
//  Coordinator.swift
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

extension NavigatingProtocol {
    func navigateTo(_ spec: AppViewSpec) {
        path.push(spec)
    }
    
    func clearPath() {
        path.popToRoot()
    }
}

open class Coordinator {
    weak var parentCoordinator: Coordinator?
}

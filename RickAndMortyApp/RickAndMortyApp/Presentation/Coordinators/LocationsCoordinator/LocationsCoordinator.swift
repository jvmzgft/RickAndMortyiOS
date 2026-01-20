//
//  LocationsCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

protocol LocationsCoordinatorProtocol: AnyObject, NavigatingProtocol {}

@Observable
class LocationsCoordinator: Coordinator, LocationsCoordinatorProtocol {
    var path: AppPath = AppPath()

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        switch destination {
        case .locations:
            path.popToRoot()
        default:
            (parentCoordinator as? TabBarCoordinatorProtocol)?.handleDeeplink(destination: destination)
        }
    }
}

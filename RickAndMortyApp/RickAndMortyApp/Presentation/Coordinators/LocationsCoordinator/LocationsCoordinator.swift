//
//  LocationsCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

protocol LocationsCoordinatorProtocol: AnyObject, NavigatingProtocol {
    func navigateToDetail(location: Location)
    func handleDeeplink(destination: NavigationDestionation)
}

@Observable
class LocationsCoordinator: Coordinator, LocationsCoordinatorProtocol {
    var myLocationsPath: LocationsPath = NavigationFactory.locationsPath

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    func navigateToDetail(location: Location) {
        myLocationsPath.push(.locationDetail(location, id: nil))
    }

    func navigateToDetail(_ spec: AppViewSpec) {
        switch spec {
        case .characterDetail, .episodeDetail, .locationDetail:
            myLocationsPath.push(spec)
        default: break
        }
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        switch destination {
        case .locations:
            myLocationsPath.popToRoot()
        default:
            (parentCoordinator as? TabBarCoordinatorProtocol)?.handleDeeplink(destination: destination)
        }
    }
}

//
//  LocationsCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

protocol LocationsCoordinatorProtocol: AnyObject {
    func navigateToDetail(location: Location)
    func handleDeeplink(destination: NavigationDestionation)
}

class LocationsCoordinator: Coordinator, LocationsCoordinatorProtocol {
    var myLocationsPath: LocationsPath = NavigationFactory.locationsPath

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    func navigateToDetail(location: Location) {
        myLocationsPath.push(.locationDetail(location))
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        print("llegue al locations coordinator")
    }
}

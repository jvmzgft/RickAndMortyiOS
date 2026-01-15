//
//  LocationsCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

enum LocationsViewSpec: ViewSpec {
    case list
    case detail(Location)
}

protocol LocationsCoordinatorProtocol: AnyObject {
    func navigateToDetail(location: Location)
    func handleDeeplink(destination: NavigationDestionation)
}

class LocationsCoordinator: Coordinator, LocationsCoordinatorProtocol {
    var myCharacterPath: LocationsPath = NavigationFactory.locationsPath

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    func navigateToDetail(location: Location) {
        myCharacterPath.push(.detail(location))
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        print("llegue al locations coordinator")
    }
}

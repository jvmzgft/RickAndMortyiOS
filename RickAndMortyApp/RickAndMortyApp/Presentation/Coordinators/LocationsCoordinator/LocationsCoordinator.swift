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
}

class LocationsCoordinator: Coordinator, LocationsCoordinatorProtocol {
    var myCharacterPath: LocationsPath = NavigationFactory.locationsPath
    
    func navigateToDetail(location: Location) {
        myCharacterPath.push(.detail(location))
    }
}

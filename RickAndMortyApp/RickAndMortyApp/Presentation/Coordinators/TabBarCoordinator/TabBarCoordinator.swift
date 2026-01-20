//
//  TabBarCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

enum NavigationDestionation: Hashable {
    case characters
    case locations
    case episodes
}

protocol TabBarCoordinatorProtocol: AnyObject {
    func handleDeeplink(destination: NavigationDestionation)
}

@Observable
class TabBarCoordinator: NavigatingCoordinator, TabBarCoordinatorProtocol {
    var selectedTab: TabItems = .characters
    var characterCoordinator: CharacterCoordinator?
    var episodesCoordinator: EpisodesCoordinator?
    var locationsCoordinator: LocationsCoordinator?
    
    init(parentCoordinator: NavigatingCoordinator) {
        super.init()
        self.parentCoordinator = parentCoordinator
        self.characterCoordinator = CharacterCoordinator(parentCoordinator: self)
        self.episodesCoordinator = EpisodesCoordinator(parentCoordinator: self)
        self.locationsCoordinator = LocationsCoordinator(parentCoordinator: self)
    }
    
    override func handleDeeplink(destination: NavigationDestionation) {
        switch destination {
        case .characters:
            selectedTab = .characters
            characterCoordinator?.handleDeeplink(destination: destination)
        case .locations:
            selectedTab = .locations
            locationsCoordinator?.handleDeeplink(destination: destination)
        case .episodes:
            selectedTab = .episodes
            episodesCoordinator?.handleDeeplink(destination: destination)
        }
    }
}

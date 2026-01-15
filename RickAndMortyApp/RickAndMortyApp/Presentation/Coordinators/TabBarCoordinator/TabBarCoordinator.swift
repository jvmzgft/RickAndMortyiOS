//
//  TabBarCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

enum NavigationDestionation: Hashable {
    case characters
    case character(String)
    case locations
    case location(String)
    case episodes
    case episode(String)
}

protocol TabBarCoordinatorProtocol: AnyObject {
    func handleDeeplink(destination: NavigationDestionation)
}

class TabBarCoordinator: Coordinator, TabBarCoordinatorProtocol {
    var selectedTab: TabItems = .characters
    lazy var characterCoordinator: CharacterCoordinator = CharacterCoordinator(parentCoordinator: self)
    lazy var episodesCoordinator: EpisodesCoordinator = EpisodesCoordinator(parentCoordinator: self)
    lazy var locationsCoordinator: LocationsCoordinator = LocationsCoordinator(parentCoordinator: self)
    
    init(parentCoordinator: Coordinator) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        print("LLego al tabBar coordinator, toca redirigir")
        switch destination {
        case .characters, .character:
            selectedTab = .characters
            characterCoordinator.handleDeeplink(destination: destination)
        case .locations, .location:
            selectedTab = .locations
            locationsCoordinator.handleDeeplink(destination: destination)
        case .episodes, .episode:
            selectedTab = .episodes
            episodesCoordinator.handleDeeplink(destination: destination)
        }
    }
}

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

@Observable
class TabBarCoordinator: Coordinator, TabBarCoordinatorProtocol {
    var selectedTab: TabItems = .characters
    var characterCoordinator: CharacterCoordinator?
    var episodesCoordinator: EpisodesCoordinator?
    var locationsCoordinator: LocationsCoordinator?
    
    init(parentCoordinator: Coordinator) {
        super.init()
        self.parentCoordinator = parentCoordinator
        self.characterCoordinator = CharacterCoordinator(parentCoordinator: self)
        self.episodesCoordinator = EpisodesCoordinator(parentCoordinator: self)
        self.locationsCoordinator = LocationsCoordinator(parentCoordinator: self)
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        print("LLego al tabBar coordinator, toca redirigir")
        switch destination {
        case .characters, .character:
            selectedTab = .characters
            characterCoordinator?.handleDeeplink(destination: destination)
        case .locations, .location:
            selectedTab = .locations
            locationsCoordinator?.handleDeeplink(destination: destination)
        case .episodes, .episode:
            selectedTab = .episodes
            episodesCoordinator?.handleDeeplink(destination: destination)
        }
    }
}

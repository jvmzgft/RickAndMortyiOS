//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

enum EpisodesViewSpec: ViewSpec {
    case list
    case detail(Episode)
}

protocol EpisodesCoordinatorProtocol: AnyObject {
    func navigateToDetail(episode: Episode)
    func navigateToCharacterDetail(id: String)
    func handleDeeplink(destination: NavigationDestionation)
}

class EpisodesCoordinator: Coordinator, EpisodesCoordinatorProtocol {
    var myCharacterPath: EpisodesPath = NavigationFactory.episodesPath

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }

    func navigateToDetail(episode: Episode) {
        myCharacterPath.push(.detail(episode))
    }
    
    func navigateToCharacterDetail(id: String) {
        if let tabBarCoordinator = parentCoordinator as? TabBarCoordinatorProtocol {
            tabBarCoordinator.handleDeeplink(destination: .character(id))
        }
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        print("llegue al episodes coordinator")
    }
}

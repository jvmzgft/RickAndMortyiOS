//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

protocol EpisodesCoordinatorProtocol: AnyObject {
    func navigateToDetail(episode: Episode)
    func navigateToCharacterDetail(id: String)
    func handleDeeplink(destination: NavigationDestionation)
}

class EpisodesCoordinator: Coordinator, EpisodesCoordinatorProtocol {
    var myEpisodesPath: EpisodesPath = NavigationFactory.episodesPath

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }

    func navigateToDetail(episode: Episode) {
        myEpisodesPath.push(.episodeDetail(episode))
    }
    
    func navigateToCharacterDetail(id: String) {
        myEpisodesPath.push(.characterDetail(nil, id: id))
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        print("llegue al episodes coordinator")
    }
}

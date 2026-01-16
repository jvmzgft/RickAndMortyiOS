//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

protocol EpisodesCoordinatorProtocol: AnyObject, DetailNavigatingProtocol {
    func navigateToDetail(episode: Episode)
    func handleDeeplink(destination: NavigationDestionation)
}

class EpisodesCoordinator: Coordinator, EpisodesCoordinatorProtocol {
    var myEpisodesPath: EpisodesPath = NavigationFactory.episodesPath

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }

    func navigateToDetail(episode: Episode) {
        myEpisodesPath.push(.episodeDetail(episode, id: nil))
    }

    func navigateToDetail(_ spec: AppViewSpec) {
        switch spec {
        case .characterDetail, .episodeDetail, .locationDetail:
            myEpisodesPath.push(spec)
        default: break
        }
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        switch destination {
        case .episodes:
            myEpisodesPath.popToRoot()
        default: break
        }
    }
}

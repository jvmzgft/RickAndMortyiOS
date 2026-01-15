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
}

class EpisodesCoordinator: Coordinator, EpisodesCoordinatorProtocol {
    var myCharacterPath: EpisodesPath = NavigationFactory.episodesPath

    func navigateToDetail(episode: Episode) {
        myCharacterPath.push(.detail(episode))
    }
}

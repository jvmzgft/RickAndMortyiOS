//
//  CharacterCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

protocol CharacterCoordinatorProtocol: AnyObject, NavigatingProtocol {
    func navigateToDetail(character: Character)
    func navigateToEpisodeDetail(id: String)
    func navigateToLocationDetail(id: String)
}

@Observable
class CharacterCoordinator: Coordinator, CharacterCoordinatorProtocol {
    var path: AppPath = AppPath()

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    func navigateToDetail(character: Character) {
        path.push(.characterDetail(character, id: nil))
    }

    func navigateToEpisodeDetail(id: String) {
        path.push(.episodeDetail(nil, id: id))
    }

    func navigateToLocationDetail(id: String) {
        path.push(.locationDetail(nil, id: id))
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        switch destination {
        case .characters:
            path.popToRoot()
        default:
            (parentCoordinator as? TabBarCoordinatorProtocol)?.handleDeeplink(destination: destination)
        }
    }
}

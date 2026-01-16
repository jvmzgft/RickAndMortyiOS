//
//  CharacterCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Combine

protocol CharacterCoordinatorProtocol: AnyObject, DetailNavigatingProtocol {
    func navigateToDetail(character: Character)
    func navigateToEpisodeDetail(id: String)
    func navigateToLocationDetail(id: String)
    func handleDeeplink(destination: NavigationDestionation)
}

class CharacterCoordinator: Coordinator, CharacterCoordinatorProtocol {
    var myCharacterPath: CharacterPath = NavigationFactory.characterPath

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    func navigateToDetail(character: Character) {
        myCharacterPath.push(.characterDetail(character, id: nil))
    }

    func navigateToEpisodeDetail(id: String) {
        myCharacterPath.push(.episodeDetail(nil, id: id))
    }

    func navigateToLocationDetail(id: String) {
        myCharacterPath.push(.locationDetail(nil, id: id))
    }

    func navigateToDetail(_ spec: AppViewSpec) {
        switch spec {
        case .characterDetail, .episodeDetail, .locationDetail:
            myCharacterPath.push(spec)
        default: break
        }
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        print("llegue al character Coordinator")
        switch destination {
        case .characters:
            myCharacterPath.popToRoot()
        case let .character(id):
            myCharacterPath.clearAndPush(.characterDetail(nil, id: id))
        default: break
        }
        
    }
}

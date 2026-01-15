//
//  CharacterCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Combine

enum CharacterViewSpec: ViewSpec {
    case list
    case detail(Character?, id: String?)
}

protocol CharacterCoordinatorProtocol: AnyObject {
    func navigateToDetail(character: Character)
    func handleDeeplink(destination: NavigationDestionation)
}

class CharacterCoordinator: Coordinator, CharacterCoordinatorProtocol {
    var myCharacterPath: CharacterPath = NavigationFactory.characterPath

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    func navigateToDetail(character: Character) {
        myCharacterPath.push(.detail(character, id: nil))
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        print("llegue al character Coordinator")
        switch destination {
        case .characters:
            myCharacterPath.popToRoot()
        case let .character(id):
            myCharacterPath.clearAndPush(.detail(nil, id: id))
        default: break
        }
        
    }
}

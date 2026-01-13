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
    case detail(Character)
}

protocol CharacterCoordinatorProtocol: AnyObject {
    func navigateToDetail(character: Character)
}

class CharacterCoordinator: Coordinator, CharacterCoordinatorProtocol {
    var myCharacterPath: CharacterPath = NavigationFactory.characterPath
    
    func navigateToDetail(character: Character) {
        myCharacterPath.push(.detail(character))
    }
}

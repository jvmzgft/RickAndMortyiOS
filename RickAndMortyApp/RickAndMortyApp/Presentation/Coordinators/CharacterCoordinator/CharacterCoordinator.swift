//
//  CharacterCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

enum CharacterViewSpec: ViewSpec {
    case list
    case detail
}

class CharacterCoordinator: Coordinator {
    var myCharacterPath: CharacterPath = NavigationFactory.characterPath
    
    var viewSpec: CharacterViewSpec = .list
}

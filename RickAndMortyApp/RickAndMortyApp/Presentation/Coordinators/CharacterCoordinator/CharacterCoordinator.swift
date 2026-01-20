//
//  CharacterCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

@Observable
class CharacterCoordinator: NavigatingCoordinator {
    
    override func handleDeeplink(destination: NavigationDestionation) {
        switch destination {
        case .characters:
            path.popToRoot()
        default:
            (parentCoordinator as? TabBarCoordinatorProtocol)?.handleDeeplink(destination: destination)
        }
    }
}

//
//  CharacterCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

protocol CharacterCoordinatorProtocol: AnyObject, NavigatingProtocol {}

@Observable
class CharacterCoordinator: Coordinator, CharacterCoordinatorProtocol {
    var path: AppPath = AppPath()

    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
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

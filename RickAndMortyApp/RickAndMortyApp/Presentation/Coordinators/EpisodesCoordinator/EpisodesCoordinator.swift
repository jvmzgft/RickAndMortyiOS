//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

@Observable
class EpisodesCoordinator: NavigatingCoordinator {
    
    override func handleDeeplink(destination: NavigationDestionation) {
        switch destination {
        case .episodes:
            path.popToRoot()
        default:
            (parentCoordinator as? TabBarCoordinatorProtocol)?.handleDeeplink(destination: destination)
        }
    }
}

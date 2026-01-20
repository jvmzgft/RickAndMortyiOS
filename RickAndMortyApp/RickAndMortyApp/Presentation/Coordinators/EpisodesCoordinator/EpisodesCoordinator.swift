//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

protocol EpisodesCoordinatorProtocol: AnyObject, NavigatingProtocol {}

@Observable
class EpisodesCoordinator: Coordinator, EpisodesCoordinatorProtocol {
    var path: AppPath = AppPath()
    
    init(parentCoordinator: Coordinator? = nil) {
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    func handleDeeplink(destination: NavigationDestionation) {
        switch destination {
        case .episodes:
            path.popToRoot()
        default:
            (parentCoordinator as? TabBarCoordinatorProtocol)?.handleDeeplink(destination: destination)
        }
    }
}

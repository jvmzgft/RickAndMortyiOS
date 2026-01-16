//
//  Coordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Foundation

protocol NavigatingProtocol: AnyObject {
    var path: AppPath { get set }
    func navigateToDetail(_ spec: AppViewSpec)
    func handleDeeplink(destination: NavigationDestionation)
}

extension NavigatingProtocol {
    func navigateToDetail(_ spec: AppViewSpec) {
        switch spec {
        case .characterDetail, .episodeDetail, .locationDetail:
            path.push(spec)
        default: break
        }
    }
}

open class Coordinator {
    weak var parentCoordinator: Coordinator?
}

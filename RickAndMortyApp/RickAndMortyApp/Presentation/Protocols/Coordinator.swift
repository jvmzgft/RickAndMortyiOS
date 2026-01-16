//
//  Coordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Foundation

protocol NavigatingProtocol: AnyObject {
    func navigateToDetail(_ spec: AppViewSpec)
    func handleDeeplink(destination: NavigationDestionation)
}

open class Coordinator {
    weak var parentCoordinator: Coordinator?
}

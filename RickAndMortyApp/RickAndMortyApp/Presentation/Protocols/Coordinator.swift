//
//  Coordinator.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Foundation

protocol DetailNavigatingProtocol: AnyObject {
    func navigateToDetail(_ spec: AppViewSpec)
}

open class Coordinator {
    weak var parentCoordinator: Coordinator?
}

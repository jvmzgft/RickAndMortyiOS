//
//  ViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Foundation

private protocol ViewModelProperties: AnyObject {
    associatedtype ViewModelCoordinator
    func getCoordinator() -> ViewModelCoordinator?
}

internal class ViewModel<ViewModelCoordinator>: ViewModelProperties {
    private weak var coordinator: Coordinator?
    
    internal init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    open func getCoordinator() -> ViewModelCoordinator? {
        return coordinator as? ViewModelCoordinator
    }
}

//
//  ViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Foundation

internal class ViewModel<ViewModelCoordinator> {
    private weak var coordinator: NavigatingCoordinator?
    
    internal init(coordinator: NavigatingCoordinator) {
        self.coordinator = coordinator
    }
    
    open func getCoordinator() -> ViewModelCoordinator? {
        return coordinator as? ViewModelCoordinator
    }
}

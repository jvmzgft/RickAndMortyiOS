//
//  ViewState.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

enum ViewState {
    case loading
    case ready
    case error
}

protocol ViewStateUpdatable: AnyObject {
    var state: ViewState { get set }
    
    func updateViewState(_ state: ViewState) async
}

extension ViewStateUpdatable {
    func updateViewState(_ newState: ViewState) async {
        await MainActor.run {
            self.state = newState
        }
    }
}

//
//  NavigationManager.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

protocol ViewSpec: Hashable {}

class NavigationManager<T: ViewSpec> : Observable {
    var path = NavigationPath()
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func push(_ screen: T) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
}

typealias CharacterPath = NavigationManager<CharacterViewSpec>

struct NavigationFactory {
    static let characterPath: NavigationManager<CharacterViewSpec> = NavigationManager<CharacterViewSpec>()
}

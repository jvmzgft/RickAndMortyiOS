//
//  NavigationManager.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Combine

protocol ViewSpec: Hashable {}

class NavigationManager<T: ViewSpec>: ObservableObject {
    @Published var path = NavigationPath()
    
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
typealias EpisodesPath = NavigationManager<EpisodesViewSpec>
typealias LocationsPath = NavigationManager<LocationsViewSpec>

struct NavigationFactory {
    static let characterPath: NavigationManager<CharacterViewSpec> = NavigationManager<CharacterViewSpec>()
    static let episodesPath: NavigationManager<EpisodesViewSpec> = NavigationManager<EpisodesViewSpec>()
    static let locationsPath: NavigationManager<LocationsViewSpec> = NavigationManager<LocationsViewSpec>()
}

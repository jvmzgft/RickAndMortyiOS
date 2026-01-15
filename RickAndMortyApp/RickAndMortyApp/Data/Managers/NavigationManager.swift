//
//  NavigationManager.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Combine

protocol ViewSpec: Hashable {}

enum AppViewSpec: ViewSpec {
    case characterList
    case characterDetail(Character?, id: String?)
    case episodeList
    case episodeDetail(Episode)
    case locationList
    case locationDetail(Location)
}

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
    
    func clearAndPush(_ screen: T) {
        path = NavigationPath()
        path.append(screen)
    }
}

typealias CharacterPath = NavigationManager<AppViewSpec>
typealias EpisodesPath = NavigationManager<AppViewSpec>
typealias LocationsPath = NavigationManager<AppViewSpec>

struct NavigationFactory {
    static let characterPath: NavigationManager<AppViewSpec> = NavigationManager<AppViewSpec>()
    static let episodesPath: NavigationManager<AppViewSpec> = NavigationManager<AppViewSpec>()
    static let locationsPath: NavigationManager<AppViewSpec> = NavigationManager<AppViewSpec>()
}

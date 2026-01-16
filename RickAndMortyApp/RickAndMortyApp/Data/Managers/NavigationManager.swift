//
//  NavigationManager.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Observation

protocol ViewSpec: Hashable {}

enum AppViewSpec: ViewSpec {
    case characterList
    case characterDetail(Character?, id: String?)
    case episodeList
    case episodeDetail(Episode?, id: String?)
    case locationList
    case locationDetail(Location?, id: String?)
}

@Observable
class NavigationManager<T: ViewSpec> {
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
    
    func clearAndPush(_ screen: T) {
        path = NavigationPath()
        path.append(screen)
    }
}

typealias AppPath = NavigationManager<AppViewSpec>

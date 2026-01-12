//
//  TabItems.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Foundation

enum TabItems {
    case characters
    case locations
    case episodes
    
    var title: String {
        switch self {
        case .characters:
            "Characters"
        case .locations:
            "Locations"
        case .episodes:
            "Episodes"
        }
    }
    
    var systemImage: String {
        switch self {
        case .characters:
            "person.2.fill"
        case .locations:
            "mountain.2.fill"
        case .episodes:
            "play.square.stack.fill"
        }
    }
}

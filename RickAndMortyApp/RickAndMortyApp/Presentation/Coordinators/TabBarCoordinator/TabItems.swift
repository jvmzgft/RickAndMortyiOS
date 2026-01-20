//
//  TabItems.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import Foundation

enum TabItems: Hashable {
    case characters
    case locations
    case episodes
    
    var title: String {
        switch self {
        case .characters:
            "tab_characters_title".localized
        case .locations:
            "tab_locations_title".localized
        case .episodes:
            "tab_episodes_title".localized
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

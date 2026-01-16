//
//  RickAndMortyAPI.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

enum RickAndMortyAPI: APIRequest {
    case characterList(page: Int? = nil, name: String? = nil)
    case character(id: String)
    case episodeList(page: Int? = nil)
    case episode(id: String)
    case locationList(page: Int? = nil)
    case location(id: String)

    var path: String {
        switch self {
        case .characterList:
            return "/api/character"
        case let .character(id):
            return "/api/character/\(id)"
        case .episodeList:
            return "/api/episode"
        case let .episode(id):
            return "/api/episode/\(id)"
        case .locationList:
            return "/api/location"
        case let .location(id):
            return "/api/location/\(id)"
        }
    }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []

        switch self {
        case let .characterList(page, name):
            if let page {
                items.append(URLQueryItem(name: "page", value: String(page)))
            }
            if let name, !name.isEmpty {
                items.append(URLQueryItem(name: "name", value: name))
            }
        case .character, .episode, .location:
            break
        case let .episodeList(page), let .locationList(page):
            if let page {
                items.append(URLQueryItem(name: "page", value: String(page)))
            }
        }

        return items
    }
}

//
//  RickAndMortyAPI.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

enum RickAndMortyAPI: APIRequest {
    case characterList(page: Int? = nil, name: String? = nil)
    case episodeList(page: Int? = nil)
    case locationList(page: Int? = nil)

    var path: String {
        switch self {
        case .characterList:
            return "/api/character"
        case .episodeList:
            return "/api/episode"
        case .locationList:
            return "/api/location"
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
        case let .episodeList(page), let .locationList(page):
            if let page {
                items.append(URLQueryItem(name: "page", value: String(page)))
            }
        }

        return items
    }
}

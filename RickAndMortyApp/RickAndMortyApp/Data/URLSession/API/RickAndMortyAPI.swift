//
//  RickAndMortyAPI.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

enum RickAndMortyAPI: APIRequest {
    case characterList(page: Int? = nil)
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
        let page: Int?
        switch self {
        case let .characterList(value), let .episodeList(value), let .locationList(value):
            page = value
        }

        guard let page else { return [] }
        return [URLQueryItem(name: "page", value: String(page))]
    }
}

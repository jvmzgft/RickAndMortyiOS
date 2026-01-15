//
//  EpisodeModels.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

struct EpisodeListResponse: Decodable {
    let info: PageInfo
    let results: [Episode]
}

struct Episode: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let airDate: String
    let code: String
    let characters: [String]
    let url: String
    let created: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case code = "episode"
        case characters
        case url
        case created
    }
}

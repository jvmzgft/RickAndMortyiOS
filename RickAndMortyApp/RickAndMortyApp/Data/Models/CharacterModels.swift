//
//  CharacterModels.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

struct CharacterListResponse: Decodable {
    let info: PageInfo
    let results: [CharacterModel]
}

struct PageInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct CharacterModel: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterLocation
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

extension CharacterModel {
    var episodeIds: [String] {
        episode.compactMap {
            URL(string: $0)?.lastPathComponent
        }
    }

    var locationIds: [String] {
        let urls = [origin.url, location.url]

        let ids = urls.compactMap {
            URL(string: $0)?.lastPathComponent
        }

        return Array(Set(ids)).sorted()
    }
}

struct CharacterLocation: Decodable, Hashable {
    let name: String
    let url: String
}

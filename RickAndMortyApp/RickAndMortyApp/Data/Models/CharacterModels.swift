//
//  CharacterModels.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

struct CharacterListResponse: Decodable {
    let info: PageInfo
    let results: [Character]
}

struct PageInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Decodable, Identifiable, Hashable {
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

extension Character {
    var episodeIds: [String] {
        episode.compactMap { $0.asLastPathComponent() }
    }
    
    var locationIds: [String] {
        let urls = [origin.url, location.url].compactMap { $0 }
        let ids = urls.compactMap { $0.asLastPathComponent() }
        return Array(Set(ids)).sorted()
    }
}

struct CharacterLocation: Decodable, Hashable {
    let name: String
    let url: String
}

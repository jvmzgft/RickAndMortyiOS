//
//  LocationModels.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

struct LocationListResponse: Decodable {
    let info: PageInfo
    let results: [Location]
}

struct Location: Decodable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}

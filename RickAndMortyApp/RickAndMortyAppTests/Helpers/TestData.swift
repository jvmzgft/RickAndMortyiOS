//
//  TestData.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation
@testable import RickAndMortyApp

func makeCharacter(id: Int) -> Character {
    Character(
        id: id,
        name: "Character \(id)",
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: CharacterLocation(name: "Earth", url: "https://example.com/origin"),
        location: CharacterLocation(name: "Earth", url: "https://example.com/location"),
        image: "https://example.com/\(id).png",
        episode: [],
        url: "https://example.com/character/\(id)",
        created: "2017-11-04T18:48:46.250Z"
    )
}

func makeEpisode(id: Int) -> Episode {
    Episode(
        id: id,
        name: "Episode \(id)",
        airDate: "December 2, 2013",
        code: "S01E0\(id)",
        characters: [],
        url: "https://example.com/episode/\(id)",
        created: "2017-11-10T12:56:33.798Z"
    )
}

func makeLocation(id: Int) -> Location {
    Location(
        id: id,
        name: "Location \(id)",
        type: "Planet",
        dimension: "Dimension C-137",
        residents: [],
        url: "https://example.com/location/\(id)",
        created: "2017-11-10T12:42:04.162Z"
    )
}

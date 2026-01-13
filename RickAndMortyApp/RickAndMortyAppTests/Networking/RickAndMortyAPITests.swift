//
//  RickAndMortyAPITests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import XCTest
@testable import RickAndMortyApp

final class RickAndMortyAPITests: XCTestCase {
    func testCharacterListQueryItemsWithName() {
        let endpoint = RickAndMortyAPI.characterList(page: 1, name: "morty")
        XCTAssertTrue(endpoint.queryItems.contains(URLQueryItem(name: "page", value: "1")))
        XCTAssertTrue(endpoint.queryItems.contains(URLQueryItem(name: "name", value: "morty")))
    }

    func testCharacterListQueryItemsWithoutName() {
        let endpoint = RickAndMortyAPI.characterList(page: 1, name: "")
        XCTAssertTrue(endpoint.queryItems.contains(URLQueryItem(name: "page", value: "1")))
        XCTAssertFalse(endpoint.queryItems.contains(URLQueryItem(name: "name", value: "")))
    }

    func testEpisodeListQueryItems() {
        let endpoint = RickAndMortyAPI.episodeList(page: 3)
        XCTAssertEqual(endpoint.queryItems, [URLQueryItem(name: "page", value: "3")])
    }

    func testLocationListQueryItems() {
        let endpoint = RickAndMortyAPI.locationList(page: 4)
        XCTAssertEqual(endpoint.queryItems, [URLQueryItem(name: "page", value: "4")])
    }
}

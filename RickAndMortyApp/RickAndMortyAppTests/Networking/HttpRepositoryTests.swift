//
//  HttpRepositoryTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("Pruebas de HttpRepository")
@MainActor
struct HttpRepositoryTests {
    @Test("Characters forward page and name")
    func testFetchCharactersForwardsPageAndName() async throws {
        let client = MockAPIClient()
        let expected = CharacterListResponse(
            info: .init(count: 1, pages: 1, next: nil, prev: nil),
            results: [makeCharacter(id: 7)]
        )
        client.enqueue(.success(expected))
        let repository = DefaultHttpRepository(apiClient: client)

        let response = try await repository.fetchCharacters(page: 2, name: "rick")

        #expect(response.results.first?.id == 7)
        #expect(client.requests.count == 1)
        #expect(client.requests.first?.path == "/api/character")
        #expect(client.requests.first?.queryItems == [
            URLQueryItem(name: "page", value: "2"),
            URLQueryItem(name: "name", value: "rick")
        ])
    }

    @Test("Character detail forwards its ID")
    func testFetchCharacterForwardsID() async throws {
        let client = MockAPIClient()
        client.enqueue(.success(makeCharacter(id: 7)))
        let repository = DefaultHttpRepository(apiClient: client)

        let response = try await repository.fetchCharacter(id: "7")

        #expect(response.id == 7)
        #expect(client.requests.first?.path == "/api/character/7")
        #expect(client.requests.first?.queryItems == [])
    }

    @Test("Episodes forward page")
    func testFetchEpisodesForwardsPage() async throws {
        let client = MockAPIClient()
        let expected = EpisodeListResponse(
            info: .init(count: 1, pages: 1, next: nil, prev: nil),
            results: [makeEpisode(id: 5)]
        )
        client.enqueue(.success(expected))
        let repository = DefaultHttpRepository(apiClient: client)

        let response = try await repository.fetchEpisodes(page: 3)

        #expect(response.results.first?.id == 5)
        #expect(client.requests.first?.path == "/api/episode")
        #expect(client.requests.first?.queryItems == [URLQueryItem(name: "page", value: "3")])
    }

    @Test("Episode detail forwards its ID")
    func testFetchEpisodeForwardsID() async throws {
        let client = MockAPIClient()
        client.enqueue(.success(makeEpisode(id: 5)))
        let repository = DefaultHttpRepository(apiClient: client)

        let response = try await repository.fetchEpisode(id: "5")

        #expect(response.id == 5)
        #expect(client.requests.first?.path == "/api/episode/5")
        #expect(client.requests.first?.queryItems == [])
    }

    @Test("Locations forward page")
    func testFetchLocationsForwardsPage() async throws {
        let client = MockAPIClient()
        let expected = LocationListResponse(
            info: .init(count: 1, pages: 1, next: nil, prev: nil),
            results: [makeLocation(id: 9)]
        )
        client.enqueue(.success(expected))
        let repository = DefaultHttpRepository(apiClient: client)

        let response = try await repository.fetchLocations(page: 4)

        #expect(response.results.first?.id == 9)
        #expect(client.requests.first?.path == "/api/location")
        #expect(client.requests.first?.queryItems == [URLQueryItem(name: "page", value: "4")])
    }

    @Test("Location detail forwards its ID")
    func testFetchLocationForwardsID() async throws {
        let client = MockAPIClient()
        client.enqueue(.success(makeLocation(id: 9)))
        let repository = DefaultHttpRepository(apiClient: client)

        let response = try await repository.fetchLocation(id: "9")

        #expect(response.id == 9)
        #expect(client.requests.first?.path == "/api/location/9")
        #expect(client.requests.first?.queryItems == [])
    }

    @Test("Characters accept nil filters and empty results")
    func testFetchCharactersWithoutFilters() async throws {
        let client = MockAPIClient()
        client.enqueue(.success(CharacterListResponse(
            info: .init(count: 0, pages: 0, next: nil, prev: nil), results: []
        )))
        let repository = DefaultHttpRepository(apiClient: client)

        let response = try await repository.fetchCharacters(page: nil, name: nil)

        #expect(response.results.isEmpty)
        #expect(client.requests.first?.queryItems == [])
    }

    @Test("Client errors propagate unchanged")
    func testPropagatesClientError() async {
        let client = MockAPIClient()
        client.enqueue(MockAPIClient.MockError.emptyQueue)
        let repository = DefaultHttpRepository(apiClient: client)

        await #expect(throws: MockAPIClient.MockError.emptyQueue) {
            _ = try await repository.fetchCharacter(id: "7")
        }
    }
}

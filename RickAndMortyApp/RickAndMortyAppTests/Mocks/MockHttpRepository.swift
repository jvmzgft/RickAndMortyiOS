//
//  MockHttpRepository.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

@testable import RickAndMortyApp

@MainActor
final class MockHttpRepository: HttpRepository {
    
    enum Operation: Equatable {
        case fetchCharacters(page: Int?, name: String?)
        case fetchCharacter(id: String)
        case fetchEpisodes(page: Int?)
        case fetchEpisode(id: String)
        case fetchLocations(page: Int?)
        case fetchLocation(id: String)
    }

    enum MockError: Error {
        case emptyQueue
    }

    private(set) var operations: [Operation] = []
    var charactersResults: [Result<CharacterListResponse, Error>] = []
    var characterResults: [Result<CharacterModel, Error>] = []
    var episodesResults: [Result<EpisodeListResponse, Error>] = []
    var episodeResults: [Result<Episode, Error>] = []
    var locationsResults: [Result<LocationListResponse, Error>] = []
    var locationResults: [Result<Location, Error>] = []

    func fetchCharacters(page: Int?, name: String?) async throws -> CharacterListResponse {
        operations.append(.fetchCharacters(page: page, name: name))
        return try dequeue(&charactersResults)
    }

    func fetchCharacter(id: String) async throws -> CharacterModel {
        operations.append(.fetchCharacter(id: id))
        return try dequeue(&characterResults)
    }

    func fetchEpisodes(page: Int?) async throws -> EpisodeListResponse {
        operations.append(.fetchEpisodes(page: page))
        return try dequeue(&episodesResults)
    }

    func fetchEpisode(id: String) async throws -> Episode {
        operations.append(.fetchEpisode(id: id))
        return try dequeue(&episodeResults)
    }

    func fetchLocations(page: Int?) async throws -> LocationListResponse {
        operations.append(.fetchLocations(page: page))
        return try dequeue(&locationsResults)
    }

    func fetchLocation(id: String) async throws -> Location {
        operations.append(.fetchLocation(id: id))
        return try dequeue(&locationResults)
    }

    private func dequeue<Response>(_ results: inout [Result<Response, Error>]) throws -> Response {
        guard !results.isEmpty else { throw MockError.emptyQueue }
        return try results.removeFirst().get()
    }
}

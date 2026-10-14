//
//  DefaultHttpRepository.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

final class DefaultHttpRepository: HttpRepository {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchCharacters(page: Int?, name: String?) async throws -> CharacterListResponse {
        try await apiClient.send(RickAndMortyAPI.characterList(page: page, name: name))
    }

    func fetchCharacter(id: String) async throws -> CharacterModel {
        try await apiClient.send(RickAndMortyAPI.character(id: id))
    }

    func fetchEpisodes(page: Int?) async throws -> EpisodeListResponse {
        try await apiClient.send(RickAndMortyAPI.episodeList(page: page))
    }

    func fetchEpisode(id: String) async throws -> Episode {
        try await apiClient.send(RickAndMortyAPI.episode(id: id))
    }

    func fetchLocations(page: Int?) async throws -> LocationListResponse {
        try await apiClient.send(RickAndMortyAPI.locationList(page: page))
    }

    func fetchLocation(id: String) async throws -> Location {
        try await apiClient.send(RickAndMortyAPI.location(id: id))
    }
}

//
//  HttpRepository.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

protocol HttpRepository {
    func fetchCharacters(page: Int?, name: String?) async throws -> CharacterListResponse
    func fetchCharacter(id: String) async throws -> CharacterModel
    func fetchEpisodes(page: Int?) async throws -> EpisodeListResponse
    func fetchEpisode(id: String) async throws -> Episode
    func fetchLocations(page: Int?) async throws -> LocationListResponse
    func fetchLocation(id: String) async throws -> Location
}

//
//  DependencyInjectorUseCaseTests.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

import Testing
@testable import RickAndMortyApp

@Suite("DependencyInjector UseCases")
@MainActor
struct DependencyInjectorUseCaseTests {
    @Test("Character list factory uses the injected repository")
    func characterListUsesInjectedRepository() async throws {
        let repository = MockHttpRepository()
        let characters = [makeCharacter(id: 42)]
        repository.charactersResults = [.success(CharacterListResponse(
            info: .init(count: 81, pages: 5, next: "next", prev: "prev"),
            results: characters
        ))]
        let useCase = DependencyInjector.getCharacterListUseCase(repository: repository)

        let response = try await useCase.handle(.init(page: 2, name: "rick"))

        #expect(response.results == characters)
        #expect(response.info.count == 81)
        #expect(response.info.pages == 5)
        #expect(response.info.next == "next")
        #expect(response.info.prev == "prev")
        #expect(repository.operations == [.fetchCharacters(page: 2, name: "rick")])
    }

    @Test("Character detail factory uses the injected repository")
    func characterDetailUsesInjectedRepository() async throws {
        let repository = MockHttpRepository()
        let character = makeCharacter(id: 43)
        repository.characterResults = [.success(character)]
        let useCase = DependencyInjector.getCharacterDetailUseCase(repository: repository)

        let response = try await useCase.handle("43")

        #expect(response == character)
        #expect(repository.operations == [.fetchCharacter(id: "43")])
    }

    @Test("Episode list factory uses the injected repository")
    func episodeListUsesInjectedRepository() async throws {
        let repository = MockHttpRepository()
        let episodes = [makeEpisode(id: 17)]
        repository.episodesResults = [.success(EpisodeListResponse(
            info: .init(count: 51, pages: 3, next: "next", prev: "prev"),
            results: episodes
        ))]
        let useCase = DependencyInjector.getEpisodeListUseCase(repository: repository)

        let response = try await useCase.handle(2)

        #expect(response.results == episodes)
        #expect(response.info.count == 51)
        #expect(response.info.pages == 3)
        #expect(response.info.next == "next")
        #expect(response.info.prev == "prev")
        #expect(repository.operations == [.fetchEpisodes(page: 2)])
    }

    @Test("Episode detail factory uses the injected repository")
    func episodeDetailUsesInjectedRepository() async throws {
        let repository = MockHttpRepository()
        let episode = makeEpisode(id: 18)
        repository.episodeResults = [.success(episode)]
        let useCase = DependencyInjector.getEpisodeDetailUseCase(repository: repository)

        let response = try await useCase.handle("18")

        #expect(response == episode)
        #expect(repository.operations == [.fetchEpisode(id: "18")])
    }

    @Test("Location list factory uses the injected repository")
    func locationListUsesInjectedRepository() async throws {
        let repository = MockHttpRepository()
        let locations = [makeLocation(id: 23)]
        repository.locationsResults = [.success(LocationListResponse(
            info: .init(count: 126, pages: 7, next: "next", prev: "prev"),
            results: locations
        ))]
        let useCase = DependencyInjector.getLocationListUseCase(repository: repository)

        let response = try await useCase.handle(3)

        #expect(response.results == locations)
        #expect(response.info.count == 126)
        #expect(response.info.pages == 7)
        #expect(response.info.next == "next")
        #expect(response.info.prev == "prev")
        #expect(repository.operations == [.fetchLocations(page: 3)])
    }

    @Test("Location detail factory uses the injected repository")
    func locationDetailUsesInjectedRepository() async throws {
        let repository = MockHttpRepository()
        let location = makeLocation(id: 24)
        repository.locationResults = [.success(location)]
        let useCase = DependencyInjector.getLocationDetailUseCase(repository: repository)

        let response = try await useCase.handle("24")

        #expect(response == location)
        #expect(repository.operations == [.fetchLocation(id: "24")])
    }
}

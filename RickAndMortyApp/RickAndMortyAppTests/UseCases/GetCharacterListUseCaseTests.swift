//
//  GetCharacterListUseCaseTests.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

import Testing
@testable import RickAndMortyApp

@Suite("GetCharacterListUseCase")
@MainActor
struct GetCharacterListUseCaseTests {
    @Test("All concrete use cases execute through UseCase with their expected Input and Output")
    func concreteUseCasesExecuteWithExpectedInputAndOutput() async throws {
        let repository = MockHttpRepository()
        let character = makeCharacter(id: 42)
        let episode = makeEpisode(id: 17)
        let location = makeLocation(id: 23)
        let characters = CharacterListResponse(
            info: .init(count: 81, pages: 5, next: "characters-next", prev: "characters-prev"),
            results: [character]
        )
        let episodes = EpisodeListResponse(
            info: .init(count: 51, pages: 3, next: "episodes-next", prev: "episodes-prev"),
            results: [episode]
        )
        let locations = LocationListResponse(
            info: .init(count: 126, pages: 7, next: "locations-next", prev: "locations-prev"),
            results: [location]
        )
        repository.charactersResults = [.success(characters)]
        repository.characterResults = [.success(character)]
        repository.episodesResults = [.success(episodes)]
        repository.episodeResults = [.success(episode)]
        repository.locationsResults = [.success(locations)]
        repository.locationResults = [.success(location)]

        @MainActor
        func execute<Operation: UseCase>(_ operation: Operation, input: Operation.Input) async throws -> Operation.Output {
            try await operation.handle(input)
        }

        func outputType<Operation: UseCase>(for operation: Operation) -> Operation.Output.Type {
            Operation.Output.self
        }

        let characterList = try await execute(GetCharacterListUseCase(repository: repository), input: .init(page: 2, name: "rick"))
        let characterDetail = try await execute(GetCharacterDetailUseCase(repository: repository), input: "42")
        let episodeList = try await execute(GetEpisodeListUseCase(repository: repository), input: 3)
        let episodeDetail = try await execute(GetEpisodeDetailUseCase(repository: repository), input: "17")
        let locationList = try await execute(GetLocationListUseCase(repository: repository), input: 4)
        let locationDetail = try await execute(GetLocationDetailUseCase(repository: repository), input: "23")

        #expect(characterList.results == characters.results)
        #expect(characterList.info.count == characters.info.count)
        #expect(characterList.info.pages == characters.info.pages)
        #expect(characterList.info.next == characters.info.next)
        #expect(characterList.info.prev == characters.info.prev)
        #expect(characterDetail == character)
        #expect(episodeList.results == episodes.results)
        #expect(episodeList.info.count == episodes.info.count)
        #expect(episodeList.info.pages == episodes.info.pages)
        #expect(episodeList.info.next == episodes.info.next)
        #expect(episodeList.info.prev == episodes.info.prev)
        #expect(episodeDetail == episode)
        #expect(locationList.results == locations.results)
        #expect(locationList.info.count == locations.info.count)
        #expect(locationList.info.pages == locations.info.pages)
        #expect(locationList.info.next == locations.info.next)
        #expect(locationList.info.prev == locations.info.prev)
        #expect(locationDetail == location)
        #expect(outputType(for: GetCharacterListUseCase(repository: repository)) == CharacterListResponse.self)
        #expect(outputType(for: GetCharacterDetailUseCase(repository: repository)) == CharacterModel.self)
        #expect(outputType(for: GetEpisodeListUseCase(repository: repository)) == EpisodeListResponse.self)
        #expect(outputType(for: GetEpisodeDetailUseCase(repository: repository)) == Episode.self)
        #expect(outputType(for: GetLocationListUseCase(repository: repository)) == LocationListResponse.self)
        #expect(outputType(for: GetLocationDetailUseCase(repository: repository)) == Location.self)
        #expect(repository.operations == [
            .fetchCharacters(page: 2, name: "rick"),
            .fetchCharacter(id: "42"),
            .fetchEpisodes(page: 3),
            .fetchEpisode(id: "17"),
            .fetchLocations(page: 4),
            .fetchLocation(id: "23")
        ])
    }

    @Test("Forwards page and name and returns the repository response")
    func forwardsArgumentsAndResponse() async throws {
        let repository = MockHttpRepository()
        repository.charactersResults = [.success(CharacterListResponse(
            info: .init(count: 1, pages: 3, next: "next", prev: "prev"),
            results: [makeCharacter(id: 42)]
        ))]
        let useCase = GetCharacterListUseCase(repository: repository)

        let response = try await useCase.handle(.init(page: 2, name: "rick"))

        #expect(response.results.first?.id == 42)
        #expect(response.info.pages == 3)
        #expect(response.info.next == "next")
        #expect(response.info.prev == "prev")
        #expect(repository.operations == [.fetchCharacters(page: 2, name: "rick")])
    }

    @Test("Propagates repository errors")
    func propagatesError() async {
        let repository = MockHttpRepository()
        repository.charactersResults = [.failure(MockHttpRepository.MockError.emptyQueue)]
        let useCase = GetCharacterListUseCase(repository: repository)

        await #expect(throws: MockHttpRepository.MockError.emptyQueue) {
            _ = try await useCase.handle(.init(page: 1, name: nil))
        }

        #expect(repository.operations == [.fetchCharacters(page: 1, name: nil)])
    }

    @Test("Preserves empty results and a nil name")
    func handlesEmptyResults() async throws {
        let repository = MockHttpRepository()
        repository.charactersResults = [.success(CharacterListResponse(
            info: .init(count: 0, pages: 0, next: nil, prev: nil), results: []
        ))]
        let useCase = GetCharacterListUseCase(repository: repository)

        let response = try await useCase.handle(.init(page: 1, name: nil))

        #expect(response.results.isEmpty)
        #expect(response.info.next == nil)
        #expect(repository.operations == [.fetchCharacters(page: 1, name: nil)])
    }
}

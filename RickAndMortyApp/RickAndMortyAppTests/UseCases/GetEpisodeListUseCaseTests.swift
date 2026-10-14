//
//  GetEpisodeListUseCaseTests.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

import Testing
@testable import RickAndMortyApp

@Suite("GetEpisodeListUseCase")
@MainActor
struct GetEpisodeListUseCaseTests {
    @Test("Forwards the page and preserves results and all metadata")
    func forwardsArgumentsAndResponse() async throws {
        let repository = MockHttpRepository()
        let episodes = [makeEpisode(id: 17), makeEpisode(id: 18)]
        repository.episodesResults = [.success(EpisodeListResponse(
            info: .init(count: 51, pages: 3, next: "next", prev: "prev"),
            results: episodes
        ))]
        let useCase = GetEpisodeListUseCase(repository: repository)

        let response = try await useCase.handle(2)

        #expect(response.results == episodes)
        #expect(response.info.count == 51)
        #expect(response.info.pages == 3)
        #expect(response.info.next == "next")
        #expect(response.info.prev == "prev")
        #expect(repository.operations == [.fetchEpisodes(page: 2)])
    }

    @Test("Propagates repository errors without other operations")
    func propagatesError() async {
        let repository = MockHttpRepository()
        repository.episodesResults = [.failure(MockHttpRepository.MockError.emptyQueue)]
        let useCase = GetEpisodeListUseCase(repository: repository)

        await #expect(throws: MockHttpRepository.MockError.emptyQueue) {
            _ = try await useCase.handle(4)
        }

        #expect(repository.operations == [.fetchEpisodes(page: 4)])
    }

    @Test("Preserves empty results and terminal pagination metadata")
    func handlesEmptyResults() async throws {
        let repository = MockHttpRepository()
        repository.episodesResults = [.success(EpisodeListResponse(
            info: .init(count: 0, pages: 0, next: nil, prev: nil), results: []
        ))]
        let useCase = GetEpisodeListUseCase(repository: repository)

        let response = try await useCase.handle(1)

        #expect(response.results.isEmpty)
        #expect(response.info.count == 0)
        #expect(response.info.pages == 0)
        #expect(response.info.next == nil)
        #expect(response.info.prev == nil)
        #expect(repository.operations == [.fetchEpisodes(page: 1)])
    }
}

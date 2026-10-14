//
//  GetEpisodeDetailUseCaseTests.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

import Testing
@testable import RickAndMortyApp

@Suite("GetEpisodeDetailUseCase")
@MainActor
struct GetEpisodeDetailUseCaseTests {
    @Test("Forwards the ID and returns the complete episode")
    func forwardsArgumentsAndResponse() async throws {
        let repository = MockHttpRepository()
        let episode = makeEpisode(id: 17)
        repository.episodeResults = [.success(episode)]
        let useCase = GetEpisodeDetailUseCase(repository: repository)

        let response = try await useCase.handle("17")

        #expect(response == episode)
        #expect(repository.operations == [.fetchEpisode(id: "17")])
    }

    @Test("Propagates repository errors without other operations")
    func propagatesError() async {
        let repository = MockHttpRepository()
        repository.episodeResults = [.failure(MockHttpRepository.MockError.emptyQueue)]
        let useCase = GetEpisodeDetailUseCase(repository: repository)

        await #expect(throws: MockHttpRepository.MockError.emptyQueue) {
            _ = try await useCase.handle("999")
        }

        #expect(repository.operations == [.fetchEpisode(id: "999")])
    }
}

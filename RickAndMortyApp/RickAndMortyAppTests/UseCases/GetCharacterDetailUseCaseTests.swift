//
//  GetCharacterDetailUseCaseTests.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

import Testing
@testable import RickAndMortyApp

@Suite("GetCharacterDetailUseCase")
@MainActor
struct GetCharacterDetailUseCaseTests {
    @Test("Forwards the ID and returns the complete character")
    func forwardsArgumentsAndResponse() async throws {
        let repository = MockHttpRepository()
        let character = makeCharacter(id: 42)
        repository.characterResults = [.success(character)]
        let useCase = GetCharacterDetailUseCase(repository: repository)

        let response = try await useCase.handle("42")

        #expect(response == character)
        #expect(repository.operations == [.fetchCharacter(id: "42")])
    }

    @Test("Propagates repository errors without other operations")
    func propagatesError() async {
        let repository = MockHttpRepository()
        repository.characterResults = [.failure(MockHttpRepository.MockError.emptyQueue)]
        let useCase = GetCharacterDetailUseCase(repository: repository)

        await #expect(throws: MockHttpRepository.MockError.emptyQueue) {
            _ = try await useCase.handle("999")
        }

        #expect(repository.operations == [.fetchCharacter(id: "999")])
    }
}

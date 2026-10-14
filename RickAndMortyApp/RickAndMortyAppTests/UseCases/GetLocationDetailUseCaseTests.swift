//
//  GetLocationDetailUseCaseTests.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

import Testing
@testable import RickAndMortyApp

@Suite("GetLocationDetailUseCase")
@MainActor
struct GetLocationDetailUseCaseTests {
    @Test("Forwards the ID and returns the complete location")
    func forwardsArgumentsAndResponse() async throws {
        let repository = MockHttpRepository()
        let location = makeLocation(id: 23)
        repository.locationResults = [.success(location)]
        let useCase = GetLocationDetailUseCase(repository: repository)

        let response = try await useCase.handle("23")

        #expect(response == location)
        #expect(repository.operations == [.fetchLocation(id: "23")])
    }

    @Test("Propagates repository errors without other operations")
    func propagatesError() async {
        let repository = MockHttpRepository()
        repository.locationResults = [.failure(MockHttpRepository.MockError.emptyQueue)]
        let useCase = GetLocationDetailUseCase(repository: repository)

        await #expect(throws: MockHttpRepository.MockError.emptyQueue) {
            _ = try await useCase.handle("999")
        }

        #expect(repository.operations == [.fetchLocation(id: "999")])
    }
}

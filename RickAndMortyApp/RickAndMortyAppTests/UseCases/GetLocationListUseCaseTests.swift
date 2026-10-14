//
//  GetLocationListUseCaseTests.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

import Testing
@testable import RickAndMortyApp

@Suite("GetLocationListUseCase")
@MainActor
struct GetLocationListUseCaseTests {
    @Test("Forwards the page and preserves results and all metadata")
    func forwardsArgumentsAndResponse() async throws {
        let repository = MockHttpRepository()
        let locations = [makeLocation(id: 23), makeLocation(id: 24)]
        repository.locationsResults = [.success(LocationListResponse(
            info: .init(count: 126, pages: 7, next: "next", prev: "prev"),
            results: locations
        ))]
        let useCase = GetLocationListUseCase(repository: repository)

        let response = try await useCase.handle(3)

        #expect(response.results == locations)
        #expect(response.info.count == 126)
        #expect(response.info.pages == 7)
        #expect(response.info.next == "next")
        #expect(response.info.prev == "prev")
        #expect(repository.operations == [.fetchLocations(page: 3)])
    }

    @Test("Propagates repository errors without other operations")
    func propagatesError() async {
        let repository = MockHttpRepository()
        repository.locationsResults = [.failure(MockHttpRepository.MockError.emptyQueue)]
        let useCase = GetLocationListUseCase(repository: repository)

        await #expect(throws: MockHttpRepository.MockError.emptyQueue) {
            _ = try await useCase.handle(5)
        }

        #expect(repository.operations == [.fetchLocations(page: 5)])
    }

    @Test("Preserves empty results and terminal pagination metadata")
    func handlesEmptyResults() async throws {
        let repository = MockHttpRepository()
        repository.locationsResults = [.success(LocationListResponse(
            info: .init(count: 0, pages: 0, next: nil, prev: nil), results: []
        ))]
        let useCase = GetLocationListUseCase(repository: repository)

        let response = try await useCase.handle(1)

        #expect(response.results.isEmpty)
        #expect(response.info.count == 0)
        #expect(response.info.pages == 0)
        #expect(response.info.next == nil)
        #expect(response.info.prev == nil)
        #expect(repository.operations == [.fetchLocations(page: 1)])
    }
}

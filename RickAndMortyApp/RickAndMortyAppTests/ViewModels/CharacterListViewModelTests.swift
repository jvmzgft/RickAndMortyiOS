//
//  CharacterListViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class CharacterListViewModelTests: XCTestCase {
    func testLoadCharactersSuccess() async {
        let mock = MockHttpRepository()
        let response = CharacterListResponse(
            info: PageInfo(count: 2, pages: 1, next: nil, prev: nil),
            results: [makeCharacter(id: 1), makeCharacter(id: 2)]
        )
        mock.charactersResults.append(.success(response))

        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, useCase: GetCharacterListUseCase(repository: mock))

        await viewModel.loadCharacters()

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.characters.count, 2)
        }
        XCTAssertEqual(mock.operations, [.fetchCharacters(page: 1, name: nil)])
    }

    func testPaginationAppendsResults() async {
        let mock = MockHttpRepository()
        let page1 = CharacterListResponse(
            info: PageInfo(count: 3, pages: 2, next: "next", prev: nil),
            results: [makeCharacter(id: 1), makeCharacter(id: 2)]
        )
        let page2 = CharacterListResponse(
            info: PageInfo(count: 3, pages: 2, next: nil, prev: "prev"),
            results: [makeCharacter(id: 3)]
        )
        mock.charactersResults = [.success(page1), .success(page2)]

        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, useCase: GetCharacterListUseCase(repository: mock))

        await viewModel.loadCharacters()
        if let last = viewModel.characters.last {
            await viewModel.loadNextPageIfNeeded(currentItem: last)
        }

        await MainActor.run {
            XCTAssertEqual(viewModel.characters.count, 3)
            XCTAssertFalse(viewModel.isLoadingNextPage)
        }
        XCTAssertEqual(mock.operations, [
            .fetchCharacters(page: 1, name: nil),
            .fetchCharacters(page: 2, name: nil)
        ])
    }

    func testSearchUsesAPIAndUpdatesResults() async {
        let mock = MockHttpRepository()
        let response = CharacterListResponse(
            info: PageInfo(count: 1, pages: 1, next: nil, prev: nil),
            results: [makeCharacter(id: 42)]
        )
        mock.charactersResults.append(.success(response))

        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, useCase: GetCharacterListUseCase(repository: mock))

        viewModel.updateSearch("rick")
        await waitFor(timeout: 1.0) { await MainActor.run { viewModel.state == .ready } }
        await waitFor(timeout: 1.0) { await MainActor.run { viewModel.characters.count == 1 } }

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.characters.count, 1)
        }
        XCTAssertEqual(mock.operations, [.fetchCharacters(page: 1, name: "rick")])
    }

    func testSearch404ClearsResults() async {
        let mock = MockHttpRepository()
        mock.charactersResults.append(.failure(NetworkError.statusCode(404)))

        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, useCase: GetCharacterListUseCase(repository: mock))

        viewModel.updateSearch("unknown")
        await waitFor(timeout: 1.0) { await MainActor.run { viewModel.state == .ready } }

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .error)
            XCTAssertTrue(viewModel.characters.isEmpty)
        }
        XCTAssertEqual(mock.operations, [.fetchCharacters(page: 1, name: "unknown")])
    }

    func testSelectCharacterNotifiesCoordinator() async {
        let mock = MockHttpRepository()
        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, useCase: GetCharacterListUseCase(repository: mock))
        let character = makeCharacter(id: 10)

        viewModel.selectCharacter(character)

        await MainActor.run {
            XCTAssertEqual(coordinator.lastDetailSpec, .characterDetail(character, id: nil))
        }
        XCTAssertTrue(mock.operations.isEmpty)
    }
}

private func waitFor(timeout: TimeInterval, condition: @escaping @Sendable () async -> Bool) async {
    let deadline = Date().addingTimeInterval(timeout)
    while Date() < deadline {
        if await condition() { return }
        try? await Task.sleep(nanoseconds: 50_000_000)
    }
}

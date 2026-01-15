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
        let mock = MockAPIClient()
        let response = CharacterListResponse(
            info: PageInfo(count: 2, pages: 1, next: nil, prev: nil),
            results: [makeCharacter(id: 1), makeCharacter(id: 2)]
        )
        mock.enqueue(.success(response))

        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, apiClient: mock)

        await viewModel.loadCharacters()

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.characters.count, 2)
        }
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertTrue(mock.requests[0].queryItems.contains(URLQueryItem(name: "page", value: "1")))
    }

    func testPaginationAppendsResults() async {
        let mock = MockAPIClient()
        let page1 = CharacterListResponse(
            info: PageInfo(count: 3, pages: 2, next: "next", prev: nil),
            results: [makeCharacter(id: 1), makeCharacter(id: 2)]
        )
        let page2 = CharacterListResponse(
            info: PageInfo(count: 3, pages: 2, next: nil, prev: "prev"),
            results: [makeCharacter(id: 3)]
        )
        mock.enqueue(.success(page1))
        mock.enqueue(.success(page2))

        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, apiClient: mock)

        await viewModel.loadCharacters()
        if let last = viewModel.characters.last {
            await viewModel.loadNextPageIfNeeded(currentItem: last)
        }

        await MainActor.run {
            XCTAssertEqual(viewModel.characters.count, 3)
            XCTAssertFalse(viewModel.isLoadingNextPage)
        }
        XCTAssertEqual(mock.requests.count, 2)
    }

    func testSearchUsesAPIAndUpdatesResults() async {
        let mock = MockAPIClient()
        let response = CharacterListResponse(
            info: PageInfo(count: 1, pages: 1, next: nil, prev: nil),
            results: [makeCharacter(id: 42)]
        )
        mock.enqueue(.success(response))

        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, apiClient: mock)

        viewModel.updateSearch("rick")
        await waitFor(timeout: 1.0) { await MainActor.run { viewModel.state == .ready } }
        await waitFor(timeout: 1.0) { await MainActor.run { viewModel.characters.count == 1 } }

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.characters.count, 1)
        }
        XCTAssertTrue(mock.requests.last?.queryItems.contains(URLQueryItem(name: "name", value: "rick")) == true)
    }

    func testSearch404ClearsResults() async {
        let mock = MockAPIClient()
        mock.enqueue(NetworkError.statusCode(404))

        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, apiClient: mock)

        viewModel.updateSearch("unknown")
        await waitFor(timeout: 1.0) { await MainActor.run { viewModel.state == .ready } }

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertTrue(viewModel.characters.isEmpty)
        }
    }

    func testSelectCharacterNotifiesCoordinator() async {
        let mock = MockAPIClient()
        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterListViewModel(coordinator: coordinator, apiClient: mock)
        let character = makeCharacter(id: 10)

        viewModel.selectCharacter(character)

        await MainActor.run {
            XCTAssertEqual(coordinator.navigatedCharacter?.id, character.id)
        }
    }
}

private func waitFor(timeout: TimeInterval, condition: @escaping @Sendable () async -> Bool) async {
    let deadline = Date().addingTimeInterval(timeout)
    while Date() < deadline {
        if await condition() { return }
        try? await Task.sleep(nanoseconds: 50_000_000)
    }
}

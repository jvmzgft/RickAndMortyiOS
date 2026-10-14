//
//  EpisodeDetailsViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class EpisodeDetailsViewModelTests: XCTestCase {
    func testInitWithEpisodeSetsReady() async {
        let coordinator = MockEpisodesCoordinator()
        let episode = makeEpisode(id: 1)
        let viewModel = EpisodeDetailsViewModel(episode: episode, coordinator: coordinator)

        XCTAssertEqual(viewModel.state, .ready)
        XCTAssertEqual(viewModel.episode?.id, 1)
    }

    func testLoadEpisodeByIdSuccess() async {
        let mock = MockHttpRepository()
        let episode = makeEpisode(id: 5)
        mock.episodeResults.append(.success(episode))
        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeDetailsViewModel(id: "5", coordinator: coordinator, useCase: GetEpisodeDetailUseCase(repository: mock))

        await viewModel.loadEpisodeIfNeeded()

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.episode?.id, 5)
        }
        XCTAssertEqual(mock.operations, [.fetchEpisode(id: "5")])
    }

    func testHandleCharacterTapNavigates() async {
        let mock = MockHttpRepository()
        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeDetailsViewModel(id: "1", coordinator: coordinator, useCase: GetEpisodeDetailUseCase(repository: mock))
        let loadedCoordinator = MockEpisodesCoordinator()
        let loadedViewModel = EpisodeDetailsViewModel(episode: makeEpisode(id: 1), coordinator: loadedCoordinator)

        loadedViewModel.handleCharacterTap("77")
        XCTAssertEqual(loadedCoordinator.lastDetailSpec, .characterDetail(nil, id: "77"))

        viewModel.handleCharacterTap("77")

        XCTAssertEqual(coordinator.lastDetailSpec, .characterDetail(nil, id: "77"))
        XCTAssertTrue(mock.operations.isEmpty)
    }

    func testHandleSeeAllCharactersDeeplink() async {
        let mock = MockHttpRepository()
        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeDetailsViewModel(id: "1", coordinator: coordinator, useCase: GetEpisodeDetailUseCase(repository: mock))
        let loadedCoordinator = MockEpisodesCoordinator()
        let loadedViewModel = EpisodeDetailsViewModel(episode: makeEpisode(id: 1), coordinator: loadedCoordinator)

        loadedViewModel.handleSeeAllCharacters()
        XCTAssertEqual(loadedCoordinator.lastDeeplink, .characters)

        viewModel.handleSeeAllCharacters()

        XCTAssertEqual(coordinator.lastDeeplink, .characters)
        XCTAssertTrue(mock.operations.isEmpty)
    }
}

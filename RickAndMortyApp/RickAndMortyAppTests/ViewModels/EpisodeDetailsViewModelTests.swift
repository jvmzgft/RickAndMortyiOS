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
        let mock = MockAPIClient()
        let episode = makeEpisode(id: 5)
        mock.enqueue(.success(episode))
        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeDetailsViewModel(id: "5", coordinator: coordinator, apiClient: mock)

        await viewModel.loadEpisodeIfNeeded()

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.episode?.id, 5)
        }
    }

    func testHandleCharacterTapNavigates() async {
        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeDetailsViewModel(episode: makeEpisode(id: 1), coordinator: coordinator)

        viewModel.handleCharacterTap("77")

        XCTAssertEqual(coordinator.lastDetailSpec, .characterDetail(nil, id: "77"))
    }

    func testHandleSeeAllCharactersDeeplink() async {
        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeDetailsViewModel(episode: makeEpisode(id: 1), coordinator: coordinator)

        viewModel.handleSeeAllCharacters()

        XCTAssertEqual(coordinator.lastDeeplink, .characters)
    }
}

//
//  EpisodeListViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class EpisodeListViewModelTests: XCTestCase {
    func testLoadEpisodesSuccess() async {
        let mock = MockAPIClient()
        let response = EpisodeListResponse(
            info: PageInfo(count: 1, pages: 1, next: nil, prev: nil),
            results: [makeEpisode(id: 1)]
        )
        mock.enqueue(.success(response))

        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeListViewModel(coordinator: coordinator, apiClient: mock)

        await viewModel.loadEpisodes()

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.episodes.count, 1)
        }
    }

    func testPaginationAppendsEpisodes() async {
        let mock = MockAPIClient()
        let page1 = EpisodeListResponse(
            info: PageInfo(count: 3, pages: 2, next: "next", prev: nil),
            results: [makeEpisode(id: 1), makeEpisode(id: 2)]
        )
        let page2 = EpisodeListResponse(
            info: PageInfo(count: 3, pages: 2, next: nil, prev: "prev"),
            results: [makeEpisode(id: 3)]
        )
        mock.enqueue(.success(page1))
        mock.enqueue(.success(page2))

        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeListViewModel(coordinator: coordinator, apiClient: mock)

        await viewModel.loadEpisodes()
        if let last = viewModel.episodes.last {
            await viewModel.loadNextPageIfNeeded(currentItem: last)
        }

        await MainActor.run {
            XCTAssertEqual(viewModel.episodes.count, 3)
            XCTAssertFalse(viewModel.isLoadingNextPage)
        }
        XCTAssertEqual(mock.requests.count, 2)
    }

    func testSelectEpisodeNotifiesCoordinator() async {
        let mock = MockAPIClient()
        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeListViewModel(coordinator: coordinator, apiClient: mock)
        let episode = makeEpisode(id: 10)

        viewModel.selectEpisode(episode)

        await MainActor.run {
            XCTAssertEqual(coordinator.lastDetailSpec, .episodeDetail(episode, id: nil))
        }
    }
}

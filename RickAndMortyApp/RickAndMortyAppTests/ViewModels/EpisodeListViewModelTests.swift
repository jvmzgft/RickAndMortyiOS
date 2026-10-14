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
        let mock = MockHttpRepository()
        let response = EpisodeListResponse(
            info: PageInfo(count: 1, pages: 1, next: nil, prev: nil),
            results: [makeEpisode(id: 1)]
        )
        mock.episodesResults.append(.success(response))

        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeListViewModel(coordinator: coordinator, useCase: GetEpisodeListUseCase(repository: mock))

        await viewModel.loadEpisodes()

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.episodes.count, 1)
        }
        XCTAssertEqual(mock.operations, [.fetchEpisodes(page: 1)])
    }

    func testPaginationAppendsEpisodes() async {
        let mock = MockHttpRepository()
        let page1 = EpisodeListResponse(
            info: PageInfo(count: 3, pages: 2, next: "next", prev: nil),
            results: [makeEpisode(id: 1), makeEpisode(id: 2)]
        )
        let page2 = EpisodeListResponse(
            info: PageInfo(count: 3, pages: 2, next: nil, prev: "prev"),
            results: [makeEpisode(id: 3)]
        )
        mock.episodesResults = [.success(page1), .success(page2)]

        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeListViewModel(coordinator: coordinator, useCase: GetEpisodeListUseCase(repository: mock))

        await viewModel.loadEpisodes()
        if let last = viewModel.episodes.last {
            await viewModel.loadNextPageIfNeeded(currentItem: last)
        }

        await MainActor.run {
            XCTAssertEqual(viewModel.episodes.count, 3)
            XCTAssertFalse(viewModel.isLoadingNextPage)
        }
        XCTAssertEqual(mock.operations, [.fetchEpisodes(page: 1), .fetchEpisodes(page: 2)])
    }

    func testSelectEpisodeNotifiesCoordinator() async {
        let mock = MockHttpRepository()
        let coordinator = MockEpisodesCoordinator()
        let viewModel = EpisodeListViewModel(coordinator: coordinator, useCase: GetEpisodeListUseCase(repository: mock))
        let episode = makeEpisode(id: 10)

        viewModel.selectEpisode(episode)

        await MainActor.run {
            XCTAssertEqual(coordinator.lastDetailSpec, .episodeDetail(episode, id: nil))
        }
        XCTAssertTrue(mock.operations.isEmpty)
    }
}

//
//  EpisodeListViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI
import Combine

class EpisodeListViewModel: ViewModel<EpisodesCoordinator>, ViewStateUpdatable {
    @Published var state: ViewState = .loading
    @Published private(set) var episodes: [Episode] = []
    @Published private(set) var isLoadingNextPage = false

    private let apiClient: APIClient
    private var currentPage = 1
    private var hasNextPage = false

    init(coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadEpisodes() async {
        await updateViewState(.loading)

        do {
            let response: EpisodeListResponse = try await apiClient.send(RickAndMortyAPI.episodeList(page: currentPage))
            episodes = response.results
            hasNextPage = response.info.next != nil
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }

    func loadNextPageIfNeeded(currentItem: Episode) async {
        guard state == .ready else { return }
        guard hasNextPage, !isLoadingNextPage else { return }
        guard currentItem.id == episodes.last?.id else { return }

        isLoadingNextPage = true
        currentPage += 1

        do {
            let response: EpisodeListResponse = try await apiClient.send(RickAndMortyAPI.episodeList(page: currentPage))
            episodes.append(contentsOf: response.results)
            hasNextPage = response.info.next != nil
        } catch {
            hasNextPage = false
        }

        isLoadingNextPage = false
    }
}

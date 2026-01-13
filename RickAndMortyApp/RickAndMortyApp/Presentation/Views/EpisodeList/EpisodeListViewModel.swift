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

    private let apiClient: APIClient

    init(coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadEpisodes() async {
        await updateViewState(.loading)

        do {
            let response: EpisodeListResponse = try await apiClient.send(RickAndMortyAPI.episodeList())
            episodes = response.results
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }
}

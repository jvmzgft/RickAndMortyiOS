//
//  EpisodeDetailsViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import Foundation
import Observation

@Observable
class EpisodeDetailsViewModel: ViewModel<NavigatingProtocol>, ViewStateUpdatable {
    var state: ViewState = .loading
    private(set) var episode: Episode?

    private let apiClient: APIClient?
    private let episodeId: String?
    
    init(episode: Episode, coordinator: Coordinator) {
        self.episode = episode
        self.episodeId = nil
        self.apiClient = nil
        super.init(coordinator: coordinator)
        self.state = .ready
    }

    init(id: String?, coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
        self.episode = nil
        self.episodeId = id
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadEpisodeIfNeeded() async {
        guard episode == nil, let episodeId else {
            await updateViewState(.ready)
            return
        }

        await updateViewState(.loading)

        guard let apiClient else {
            await updateViewState(.error)
            return
        }

        do {
            let response: Episode = try await apiClient.send(RickAndMortyAPI.episode(id: episodeId))
            episode = response
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }

    func handleCharacterTap(_ characterId: String) {
        getCoordinator()?.navigateTo(.characterDetail(nil, id: characterId))
    }

    func handleSeeAllCharacters() {
        getCoordinator()?.handleDeeplink(destination: .characters)
    }
    
    func clearPath() {
        getCoordinator()?.clearPath()
    }

}

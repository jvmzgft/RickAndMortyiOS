//
//  CharacterDetailsViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import Foundation
import Observation

@Observable
class CharacterDetailsViewModel: ViewModel<NavigatingProtocol>, ViewStateUpdatable {
    var state: ViewState = .loading
    private(set) var character: Character?

    private let apiClient: APIClient?
    private let characterId: String?

    init(character: Character, coordinator: NavigatingCoordinator) {
        self.character = character
        self.characterId = nil
        self.apiClient = nil
        super.init(coordinator: coordinator)
        self.state = .ready
    }

    init(
        id: String?,
         coordinator: NavigatingCoordinator,
         apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()
    ) {
        self.character = nil
        self.characterId = id
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadCharacterIfNeeded() async {
        guard character == nil else {
            await updateViewState(.ready)
            return
        }

        await updateViewState(.loading)

        guard let apiClient, let characterId else {
            await updateViewState(.error)
            return
        }

        do {
            let response: Character = try await apiClient.send(RickAndMortyAPI.character(id: characterId))
            character = response
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }

    func handleEpisodeTap(_ episodeId: String) {
        getCoordinator()?.navigateTo(.episodeDetail(nil, id: episodeId))
    }

    func handleLocationTap(_ locationId: String) {
        getCoordinator()?.navigateTo(.locationDetail(nil, id: locationId))
    }

    func handleSeeAllEpisodes() {
        getCoordinator()?.handleDeeplink(destination: .episodes)
    }

    func handleSeeAllLocations() {
        getCoordinator()?.handleDeeplink(destination: .locations)
    }
    
    func clearPath() {
        getCoordinator()?.clearPath()
    }
}

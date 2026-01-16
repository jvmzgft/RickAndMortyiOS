//
//  CharacterDetailsViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import Foundation
import Combine

class CharacterDetailsViewModel: ViewModel<CharacterCoordinatorProtocol>, ViewStateUpdatable {
    @Published var state: ViewState = .loading
    @Published private(set) var character: Character?

    private let apiClient: APIClient?
    private let characterId: String?

    init(character: Character, coordinator: Coordinator) {
        self.character = character
        self.characterId = nil
        self.apiClient = nil
        super.init(coordinator: coordinator)
        self.state = .ready
    }

    init(id: String?, coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
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
        getCoordinator()?.navigateToEpisodeDetail(id: episodeId)
    }

    func handleLocationTap(_ locationId: String) {
        getCoordinator()?.navigateToLocationDetail(id: locationId)
    }
}

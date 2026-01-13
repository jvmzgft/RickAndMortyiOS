//
//  CharacterViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Combine

class CharacterListViewModel: ViewModel<TabBarCoordinator>, ViewStateUpdatable {
    
    @Published var state: ViewState = .loading
    @Published private(set) var characters: [Character] = []
    private let apiClient: APIClient

    init(coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadCharacters() async {
        await updateViewState(.loading)

        do {
            let response: CharacterListResponse = try await apiClient.send(RickAndMortyAPI.characterList())
            characters = response.results
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }
}

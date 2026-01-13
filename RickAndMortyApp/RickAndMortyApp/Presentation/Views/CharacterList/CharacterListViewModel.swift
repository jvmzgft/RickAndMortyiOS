//
//  CharacterViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Combine

class CharacterListViewModel: ViewModel<CharacterCoordinatorProtocol>, ViewStateUpdatable {
    
    @Published var state: ViewState = .loading
    @Published private(set) var characters: [Character] = []
    @Published private(set) var isLoadingNextPage = false
    private let apiClient: APIClient
    private var currentPage = 1
    private var hasNextPage = false

    init(coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadCharacters() async {
        await updateViewState(.loading)

        do {
            let response: CharacterListResponse = try await apiClient.send(RickAndMortyAPI.characterList(page: currentPage))
            characters = response.results
            hasNextPage = response.info.next != nil
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }

    func loadNextPageIfNeeded(currentItem: Character) async {
        guard state == .ready else { return }
        guard hasNextPage, !isLoadingNextPage else { return }

        isLoadingNextPage = true
        currentPage += 1

        do {
            let response: CharacterListResponse = try await apiClient.send(RickAndMortyAPI.characterList(page: currentPage))
            characters.append(contentsOf: response.results)
            hasNextPage = response.info.next != nil
        } catch {
            hasNextPage = false
        }

        isLoadingNextPage = false
    }

    func selectCharacter(_ character: Character) {
        getCoordinator()?.navigateToDetail(character: character)
    }
}

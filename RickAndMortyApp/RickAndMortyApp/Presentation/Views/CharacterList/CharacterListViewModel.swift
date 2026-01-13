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
    @Published var searchText = ""
    @Published private(set) var characters: [Character] = []
    @Published private(set) var isLoadingNextPage = false
    private let apiClient: APIClient
    private var currentPage = 1
    private var hasNextPage = true
    private var currentQuery: String?
    private var searchTask: Task<Void, Never>?

    init(coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadCharacters() async {
        await fetchCharacters(reset: true, query: nil)
    }

    func loadNextPageIfNeeded(currentItem: Character) async {
        guard state == .ready else { return }
        guard hasNextPage, !isLoadingNextPage else { return }
        guard currentItem.id == characters.last?.id else { return }

        await fetchCharacters(reset: false, query: currentQuery)
    }

    func selectCharacter(_ character: Character) {
        getCoordinator()?.navigateToDetail(character: character)
    }

    func updateSearch(_ text: String) {
        searchTask?.cancel()
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard let self, !Task.isCancelled else { return }
            await self.fetchCharacters(reset: true, query: trimmed.isEmpty ? nil : trimmed)
        }
    }

    private func fetchCharacters(reset: Bool, query: String?) async {
        if reset {
            await updateViewState(.loading)
            characters = []
            currentPage = 1
            hasNextPage = true
            currentQuery = query
        } else {
            isLoadingNextPage = true
            currentPage += 1
        }

        do {
            let response: CharacterListResponse = try await apiClient.send(
                RickAndMortyAPI.characterList(page: currentPage, name: query)
            )
            if reset {
                characters = response.results
            } else {
                characters.append(contentsOf: response.results)
            }
            hasNextPage = response.info.next != nil
            await updateViewState(.ready)
        } catch {
            if reset {
                characters = []
                hasNextPage = false
                await updateViewState(.error)
            } else {
                hasNextPage = false
            }
        }

        isLoadingNextPage = false
    }
}

//
//  EpisodeListViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI
import Observation

@Observable
class EpisodeListViewModel: ViewModel<NavigatingProtocol>, ViewStateUpdatable {
    var state: ViewState = .loading
    private(set) var episodes: [Episode] = []
    private(set) var isLoadingNextPage = false

    private let useCase: GetEpisodeListUseCase
    private var currentPage = 1
    private var hasNextPage = false
    
    init(
        coordinator: NavigatingCoordinator,
        useCase: GetEpisodeListUseCase = DependencyInjector.getEpisodeListUseCase()
    ) {
        self.useCase = useCase
        super.init(coordinator: coordinator)
    }

    func loadEpisodes() async {
        await updateViewState(.loading)

        do {
            let response = try await useCase.handle(currentPage)
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
            let response = try await useCase.handle(currentPage)
            episodes.append(contentsOf: response.results)
            hasNextPage = response.info.next != nil
        } catch {
            hasNextPage = false
        }

        isLoadingNextPage = false
    }

    func selectEpisode(_ episode: Episode) {
        getCoordinator()?.navigateTo(.episodeDetail(episode, id: nil))
    }
}

//
//  EpisodesCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct EpisodesCoordinatorView: View {
    @StateObject var coordinator: EpisodesCoordinator
    @StateObject private var path: EpisodesPath

    init(coordinator: EpisodesCoordinator = EpisodesCoordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
        _path = StateObject(wrappedValue: coordinator.myCharacterPath)
    }

    var body: some View {
        NavigationStack(path: $path.path) {
            episodeListView()
                .navigationDestination(for: EpisodesViewSpec.self) { spec in
                    switch spec {
                    case .list:
                        episodeListView()
                    case let .detail(episode):
                        EpisodeDetailsView(episode: episode)
                    }
                }
        }
    }

    @ViewBuilder
    private func episodeListView() -> some View {
        EpisodeListView(viewModel: EpisodeListViewModel(coordinator: coordinator))
    }
}

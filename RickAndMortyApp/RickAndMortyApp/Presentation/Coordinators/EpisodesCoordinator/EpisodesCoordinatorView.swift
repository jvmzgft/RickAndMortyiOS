//
//  EpisodesCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct EpisodesCoordinatorView: View {
    @StateObject var coordinator: EpisodesCoordinator

    init(coordinator: EpisodesCoordinator = EpisodesCoordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        EpisodeListView(viewModel: EpisodeListViewModel(coordinator: coordinator))
    }
}

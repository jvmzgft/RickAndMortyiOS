//
//  EpisodesCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct EpisodesCoordinatorView: View {
    @State var coordinator: EpisodesCoordinator
    @State private var path: AppPath

    init(coordinator: EpisodesCoordinator) {
        _coordinator = State(wrappedValue: coordinator)
        _path = State(wrappedValue: coordinator.path)
    }

    var body: some View {
        NavigationStack(path: $path.path) {
            ViewFactory.makeView(for: .episodeList, coordinator: coordinator)
                .navigationDestination(for: AppViewSpec.self) { spec in
                    ViewFactory.makeView(for: spec, coordinator: coordinator)
                }
                .navigationTitle(TabItems.episodes.title)
        }
    }
}

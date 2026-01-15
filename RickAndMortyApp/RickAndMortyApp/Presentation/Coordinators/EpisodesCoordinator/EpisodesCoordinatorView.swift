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

    init(coordinator: EpisodesCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
        _path = StateObject(wrappedValue: coordinator.myEpisodesPath)
    }

    var body: some View {
        NavigationStack(path: $path.path) {
            ViewFactory.makeView(for: .episodeList, coordinator: coordinator)
                .navigationDestination(for: AppViewSpec.self) { spec in
                    ViewFactory.makeView(for: spec, coordinator: coordinator)
                }
        }
    }
}

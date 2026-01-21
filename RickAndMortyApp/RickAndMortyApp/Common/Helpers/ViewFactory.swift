//
//  ViewFactory.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import SwiftUI

struct ViewFactory {
    @ViewBuilder
    static func makeView(for spec: AppViewSpec, coordinator: NavigatingCoordinator) -> some View {
        switch spec {
        case .characterList:
            if let characterCoordinator = coordinator as? CharacterCoordinator {
                DependencyInjector.characterListView(
                    coordinator: characterCoordinator,
                    viewModel: characterCoordinator.listViewModel
                )
            } else {
                DependencyInjector.characterListView(coordinator: coordinator)
            }
        case let .characterDetail(character, id):
            DependencyInjector.characterDetailView(character: character, id: id, coordinator: coordinator)
        case .episodeList:
            DependencyInjector.episodeList(coordinator: coordinator)
        case let .episodeDetail(episode, id):
            DependencyInjector.episodeDetail(episode: episode, id: id, coordinator: coordinator)
        case .locationList:
            DependencyInjector.locationList(coordinator: coordinator)
        case let .locationDetail(location, id):
            DependencyInjector.locationDetail(location: location, id: id, coordinator: coordinator)
        }
    }
    
    @ToolbarContentBuilder
    static func closeTabItemButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                action()
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 48, height: 48)
            }
        }
    }
}

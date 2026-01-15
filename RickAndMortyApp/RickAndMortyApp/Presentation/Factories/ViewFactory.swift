//
//  ViewFactory.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import SwiftUI

struct ViewFactory {
    @ViewBuilder
    static func makeView(for spec: AppViewSpec, coordinator: Coordinator) -> some View {
        switch spec {
        case .characterList:
            DependencyInjector.characterListView(coordinator: coordinator)
        case let .characterDetail(character, id):
            DependencyInjector.characterDetailView(character: character, id: id, coordinator: coordinator)
        case .episodeList:
            DependencyInjector.episodeList(coordinator: coordinator)
        case let .episodeDetail(episode):
            DependencyInjector.episodeDetail(episode: episode, coordinator: coordinator)
        case .locationList:
            DependencyInjector.locationList(coordinator: coordinator)
        case let .locationDetail(location):
            DependencyInjector.locationDetail(location: location)
        }
    }
}

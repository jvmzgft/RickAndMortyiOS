//
//  DependencyInjector.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

internal class DependencyInjector {
    static func getURLSessionAPIClient() -> URLSessionAPIClient {
        URLSessionAPIClient()
    }
    
    static func characterListView(
        coordinator: NavigatingCoordinator,
        viewModel: CharacterListViewModel? = nil
    ) -> CharacterListView {
        .init(
            viewModel: viewModel ?? CharacterListViewModel(coordinator: coordinator)
        )
    }
    
    static func characterDetailView(
        character: Character?,
        id: String?,
        coordinator: NavigatingCoordinator
    ) -> CharacterDetailsView {
        var vm: CharacterDetailsViewModel
        if let character {
            vm = .init(character: character, coordinator: coordinator)
        } else if let id {
            vm = .init(id: id, coordinator: coordinator)
        } else {
            vm = .init(id: nil, coordinator: coordinator)
        }
        return .init(viewModel: vm)
    }
    
    static func episodeList(coordinator: NavigatingCoordinator) -> EpisodeListView {
        .init(viewModel: .init(coordinator: coordinator))
    }
    
    static func episodeDetail(
        episode: Episode?,
        id: String?,
        coordinator: NavigatingCoordinator
    ) -> EpisodeDetailsView {
        var vm: EpisodeDetailsViewModel
        if let episode {
            vm = .init(episode: episode, coordinator: coordinator)
        } else if let id {
            vm = .init(id: id, coordinator: coordinator)
        } else {
            vm = .init(id: nil, coordinator: coordinator)
        }
        return .init(viewModel: vm)
    }
    
    static func locationList(coordinator: NavigatingCoordinator) -> LocationListView {
        .init(viewModel: .init(coordinator: coordinator))
    }
    
    static func locationDetail(
        location: Location?,
        id: String?,
        coordinator: NavigatingCoordinator
    ) -> LocationDetailsView {
        var vm: LocationDetailsViewModel
        if let location {
            vm = .init(location: location, coordinator: coordinator)
        } else if let id {
            vm = .init(id: id, coordinator: coordinator)
        } else {
            vm = .init(id: nil, coordinator: coordinator)
        }
        return .init(viewModel: vm)
    }
}

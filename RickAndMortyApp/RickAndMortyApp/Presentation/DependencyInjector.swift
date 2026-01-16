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
    
    static func characterListView(coordinator: Coordinator) -> CharacterListView {
        .init(viewModel: CharacterListViewModel(coordinator: coordinator))
    }
    
    static func characterDetailView(character: Character?, id: String?, coordinator: Coordinator) -> CharacterDetailsView {
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
    
    static func episodeList(coordinator: Coordinator) -> EpisodeListView {
        .init(viewModel: .init(coordinator: coordinator))
    }
    
    static func episodeDetail(episode: Episode?, id: String?, coordinator: Coordinator) -> EpisodeDetailsView {
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
    
    static func locationList(coordinator: Coordinator) -> LocationListView {
        .init(viewModel: .init(coordinator: coordinator))
    }
    
    static func locationDetail(location: Location?, id: String?, coordinator: Coordinator) -> LocationDetailsView {
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

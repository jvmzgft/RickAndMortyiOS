//
//  TabBarCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

struct TabBarCoordinatorView: View {
    @State var coordinator: TabBarCoordinator
    
    init(coordinator: TabBarCoordinator) {
        _coordinator = State(wrappedValue: coordinator)
    }
    
    var body: some View {
        let tabView = TabView(selection: $coordinator.selectedTab) {
            Tab(TabItems.characters.title, systemImage: TabItems.characters.systemImage, value: TabItems.characters) {
                if let characterCoordinator = coordinator.characterCoordinator {
                    CharacterCoordinatorView(coordinator: characterCoordinator)
                }
            }
            Tab(TabItems.episodes.title, systemImage: TabItems.episodes.systemImage, value: TabItems.episodes) {
                if let episodesCoordinator = coordinator.episodesCoordinator {
                    EpisodesCoordinatorView(coordinator: episodesCoordinator)
                }
            }
            Tab(TabItems.locations.title, systemImage: TabItems.locations.systemImage, value: TabItems.locations) {
                if let locationsCoordinator = coordinator.locationsCoordinator {
                    LocationsCoordinatorView(coordinator: locationsCoordinator)
                }
            }
            Tab(TabItems.search.title, systemImage: TabItems.search.systemImage, value: TabItems.search, role: .search) {
                NavigationStack {
                    if let characterCoordinator = coordinator.characterCoordinator {
                        DependencyInjector.characterListView(
                            coordinator: characterCoordinator,
                            viewModel: characterCoordinator.listViewModel
                        )
                    } else {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("search_not_available")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.orange)
                    }
                }
            }
        }

        if coordinator.selectedTab == .search {
            tabView
                .searchable(text: searchTextBinding, prompt: Text("search_character_placeholder".localized))
        } else {
            tabView
        }
    }

    private var searchTextBinding: Binding<String> {
        guard let listViewModel = coordinator.characterCoordinator?.listViewModel else {
            return .constant("")
        }

        return Binding(
            get: { listViewModel.searchText },
            set: { newValue in
                listViewModel.searchText = newValue
                listViewModel.updateSearch(newValue)
            }
        )
    }
}

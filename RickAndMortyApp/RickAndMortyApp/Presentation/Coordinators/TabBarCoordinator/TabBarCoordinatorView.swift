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
        TabView(selection: $coordinator.selectedTab) {
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
        }
    }
}

//
//  TabBarCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

struct TabBarCoordinatorView: View {
    @StateObject var coordinator: TabBarCoordinator
    
    init(coordinator: TabBarCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        TabView {
            Tab(TabItems.characters.title, systemImage: TabItems.characters.systemImage) {
                CharacterCoordinatorView(coordinator: coordinator.characterCoordinator)
            }
            Tab(TabItems.episodes.title, systemImage: TabItems.episodes.systemImage) {
                EpisodesCoordinatorView(coordinator: coordinator.episodesCoordinator)
            }
            Tab(TabItems.locations.title, systemImage: TabItems.locations.systemImage) {
                LocationsCoordinatorView(coordinator: coordinator.locationsCoordinator)
            }
        }
    }
}

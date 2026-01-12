//
//  TabBarCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

struct TabBarCoordinatorView: View {
    @StateObject var coordinator: TabBarCoordinator
    
    init(coordinator: TabBarCoordinator = TabBarCoordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        TabView {
            Tab(TabItems.characters.title, systemImage: TabItems.characters.systemImage) {
                CharacterCoordinatorView()
            }
            Tab(TabItems.episodes.title, systemImage: TabItems.episodes.systemImage) {
                ContentView()
            }
            Tab(TabItems.locations.title, systemImage: TabItems.locations.systemImage) {
                ContentView()
            }
        }
    }
}

//
//  CharacterCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Combine

struct CharacterCoordinatorView: View {
    @State var coordinator: CharacterCoordinator
    @StateObject private var path: CharacterPath
    
    init(coordinator: CharacterCoordinator) {
        _coordinator = State(wrappedValue: coordinator)
        _path = StateObject(wrappedValue: coordinator.myCharacterPath)
    }
    
    var body: some View {
        NavigationStack(path: $path.path) {
            ViewFactory.makeView(for: .characterList, coordinator: coordinator)
                .navigationDestination(for: AppViewSpec.self) { spec in
                    ViewFactory.makeView(for: spec, coordinator: coordinator)
                }
        }
    }
}

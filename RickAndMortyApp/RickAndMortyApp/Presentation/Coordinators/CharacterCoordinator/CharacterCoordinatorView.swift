//
//  CharacterCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI
import Combine

struct CharacterCoordinatorView: View {
    @StateObject var coordinator: CharacterCoordinator
    @StateObject private var path: CharacterPath
    
    init(coordinator: CharacterCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
        _path = StateObject(wrappedValue: coordinator.myCharacterPath)
    }
    
    var body: some View {
        NavigationStack(path: $path.path) {
            characterListView()
                .navigationDestination(for: CharacterViewSpec.self) { spec in
                    switch spec {
                    case .list:
                        characterListView()
                    case let .detail(character, id):
                        if let character {
                            CharacterDetailsView(viewModel: .init(character: character, coordinator: coordinator))
                        } else if let id {
                            CharacterDetailsView(viewModel: .init(id: id, coordinator: coordinator))
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    private func characterListView() -> some View {
        CharacterListView(viewModel: CharacterListViewModel(coordinator: coordinator))
    }
}

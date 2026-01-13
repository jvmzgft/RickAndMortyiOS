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
    
    
    init(coordinator: CharacterCoordinator = CharacterCoordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.myCharacterPath.path) {
            characterListView()
        }
    }
    
    @ViewBuilder
    private func characterListView() -> some View {
        CharacterListView(viewModel: CharacterListViewModel(coordinator: coordinator))
    }
}

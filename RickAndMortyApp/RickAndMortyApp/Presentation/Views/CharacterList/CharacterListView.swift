//
//  CharacterListView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

struct CharacterListView: View {
    @State var viewModel: CharacterListViewModel
    
    init(viewModel: CharacterListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ContentView()
    }
}

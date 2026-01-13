//
//  CharacterListView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel: CharacterListViewModel
    
    init(viewModel: CharacterListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        contentView()
        .task {
            await viewModel.loadCharacters()
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .ready:
            readyView()
        case .error:
            Text("ERROR")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    @ViewBuilder
    private func readyView() -> some View {
        List(viewModel.characters) { character in
            Button {
                viewModel.selectCharacter(character)
            } label: {
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: character.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Color.gray.opacity(0.2)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(character.name)
                            .font(.headline)
                        Text("\(character.species)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.vertical, 4)
        }
        .listStyle(.plain)
    }
}

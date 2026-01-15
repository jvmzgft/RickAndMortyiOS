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
        .searchable(text: $viewModel.searchText, prompt: "Search character")
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.updateSearch(newValue)
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
        if viewModel.characters.isEmpty {
            Text("No results available")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            List {
                ForEach(viewModel.characters) { character in
                    Button {
                        viewModel.selectCharacter(character)
                    } label: {
                        HStack(spacing: 12) {
                            CachedAsyncImage(urlString: character.image)
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
                    .onAppear {
                        guard character.id == viewModel.characters.last?.id else { return }
                        Task {
                            await viewModel.loadNextPageIfNeeded(currentItem: character)
                        }
                    }
                }
                
                if viewModel.isLoadingNextPage {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

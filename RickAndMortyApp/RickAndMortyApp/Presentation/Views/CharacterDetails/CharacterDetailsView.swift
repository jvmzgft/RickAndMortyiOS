//
//  CharacterDetailsView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct CharacterDetailsView: View {
    @StateObject private var viewModel: CharacterDetailsViewModel

    init(viewModel: CharacterDetailsViewModel) {
        _viewModel = StateObject( wrappedValue: viewModel )
    }

    var body: some View {
        contentView()
            .task {
                await viewModel.loadCharacterIfNeeded()
            }
            .navigationTitle("Character Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
    }

    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .ready:
            if let character = viewModel.character {
                detailsView(character: character)
            } else {
                Text("No results")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        case .error:
            Text("ERROR")
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    private func detailsView(character: Character) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(urlString: character.image)
                .frame(height: 260)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name)
                        .font(.title)
                        .bold()
                    Text("\(character.status) - \(character.species)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                infoRow(title: "Gender", value: character.gender)
                infoRow(title: "Type", value: character.type.isEmpty ? "Unknown" : character.type)
                infoRow(title: "Origin", value: character.origin.name)
                infoRow(title: "Current location", value: character.location.name)
                infoRow(title: "Episodes", value: "\(character.episode.count)")
            }
            .padding()
        }
    }

    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
    }
}

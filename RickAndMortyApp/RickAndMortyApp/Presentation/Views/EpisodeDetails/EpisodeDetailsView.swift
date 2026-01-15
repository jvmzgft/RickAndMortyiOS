//
//  EpisodeDetailsView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct EpisodeDetailsView: View {
    @StateObject private var viewModel: EpisodeDetailsViewModel

    init(viewModel: EpisodeDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.episode.name)
                        .font(.title)
                        .bold()
                    Text("\(viewModel.episode.code) - \(viewModel.episode.airDate)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                infoRow(title: "Air date", value: viewModel.episode.airDate)
                infoRow(title: "Code", value: viewModel.episode.code)
                infoRow(title: "URL", value: viewModel.episode.url)
                infoRow(title: "Created", value: viewModel.episode.created)

                VStack(alignment: .leading, spacing: 8) {
                    Text("CHARACTERS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    FourColumnButtonGrid(items: viewModel.episode.characterIds) { characterId in
                        viewModel.handleCharacterTap(characterId)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Episode detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
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

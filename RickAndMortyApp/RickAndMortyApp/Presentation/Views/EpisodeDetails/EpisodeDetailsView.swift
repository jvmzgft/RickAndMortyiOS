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
        contentView()
            .task {
                await viewModel.loadEpisodeIfNeeded()
            }
            .navigationTitle("Episode detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
    }

    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .ready:
            if let episode = viewModel.episode {
                detailsView(episode: episode)
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

    private func detailsView(episode: Episode) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(episode.name)
                        .font(.title)
                        .bold()
                    Text("\(episode.code) - \(episode.airDate)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                infoRow(title: "Air date", value: episode.airDate)
                infoRow(title: "Code", value: episode.code)
                infoRow(title: "URL", value: episode.url)
                infoRow(title: "Created", value: episode.created)

                VStack(alignment: .leading, spacing: 8) {
                    Text("CHARACTERS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    FourColumnButtonGrid(items: episode.characterIds) { characterId in
                        viewModel.handleCharacterTap(characterId)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
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

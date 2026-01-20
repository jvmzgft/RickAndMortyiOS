//
//  EpisodeDetailsView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct EpisodeDetailsView: View {
    @State private var viewModel: EpisodeDetailsViewModel

    init(viewModel: EpisodeDetailsViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        contentView()
            .task {
                await viewModel.loadEpisodeIfNeeded()
            }
            .navigationTitle("episode_detail_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ViewFactory.closeTabItemButton(action: viewModel.clearPath)
            }
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
                Text("generic_no_results")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        case .error:
            Text("generic_error")
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

                infoRow(title: "label_air_date".localized.uppercased(), value: episode.airDate)
                infoRow(title: "label_code".localized.uppercased(), value: episode.code)
                infoRow(title: "URL", value: episode.url)
                infoRow(title: "label_created".localized.uppercased(), value: episode.created)

                VStack(alignment: .leading, spacing: 12) {
                    Text("characters_section_title")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    FourColumnButtonGrid(items: episode.characterIds) { characterId in
                        viewModel.handleCharacterTap(characterId)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.handleSeeAllCharacters()
                        }, label: {
                            Text("see_all_characters_button".localized.uppercased())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        })
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

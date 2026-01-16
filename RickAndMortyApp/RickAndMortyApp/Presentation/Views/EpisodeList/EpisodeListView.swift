//
//  EpisodeListView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct EpisodeListView: View {
    @State private var viewModel: EpisodeListViewModel

    init(viewModel: EpisodeListViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        contentView()
            .task {
                await viewModel.loadEpisodes()
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
        List {
            ForEach(viewModel.episodes) { episode in
                Button {
                    viewModel.selectEpisode(episode)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(episode.name)
                            .font(.headline)
                        Text("\(episode.code) - \(episode.airDate)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
                .onAppear {
                    Task {
                        await viewModel.loadNextPageIfNeeded(currentItem: episode)
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

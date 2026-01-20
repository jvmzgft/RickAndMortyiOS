//
//  LocationListView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct LocationListView: View {
    @State private var viewModel: LocationListViewModel

    init(viewModel: LocationListViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        contentView()
            .task {
                await viewModel.loadLocations()
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
            Text(verbatim: "ERROR")
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    @ViewBuilder
    private func readyView() -> some View {
        List {
            ForEach(viewModel.locations) { location in
                Button {
                    viewModel.selectLocation(location)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(verbatim: location.name)
                            .font(.headline)
                        Text(verbatim: "\(location.type) - \(location.dimension)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
                .onAppear {
                    Task {
                        await viewModel.loadNextPageIfNeeded(currentItem: location)
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

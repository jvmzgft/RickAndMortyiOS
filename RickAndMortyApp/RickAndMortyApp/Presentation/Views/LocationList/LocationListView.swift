//
//  LocationListView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct LocationListView: View {
    @StateObject private var viewModel: LocationListViewModel

    init(viewModel: LocationListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
            Text("ERROR")
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    @ViewBuilder
    private func readyView() -> some View {
        List {
            ForEach(viewModel.locations) { location in
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.headline)
                    Text("\(location.type) - \(location.dimension)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
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

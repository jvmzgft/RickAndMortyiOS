//
//  LocationDetailsView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct LocationDetailsView: View {
    @State private var viewModel: LocationDetailsViewModel

    init(viewModel: LocationDetailsViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        contentView()
            .task {
                await viewModel.loadLocationIfNeeded()
            }
            .navigationTitle("Location detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
    }

    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .ready:
            if let location = viewModel.location {
                detailsView(location: location)
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

    private func detailsView(location: Location) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(location.name)
                        .font(.title)
                        .bold()
                    Text("\(displayText(location.type)) - \(displayText(location.dimension))")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                infoRow(title: "Type", value: displayText(location.type))
                infoRow(title: "Dimension", value: displayText(location.dimension))
                infoRow(title: "URL", value: location.url)
                infoRow(title: "Created", value: location.created)
                infoRow(title: "Residents", value: "\(location.residents.count)")

                if let location = viewModel.location, !location.residentIds.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("RESIDENTS")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        FourColumnButtonGrid(items: location.residentIds) { characterId in
                            viewModel.handleResidentTap(characterId)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    private func displayText(_ value: String) -> String {
        value.isEmpty ? "Unknown" : value
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

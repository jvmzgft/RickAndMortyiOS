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
            .navigationTitle("location_detail_title")
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
            if let location = viewModel.location {
                detailsView(location: location)
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
                
                infoRow(title: "label_type".localized.uppercased(), value: displayText(location.type))
                infoRow(title: "label_dimension".localized.uppercased(), value: displayText(location.dimension))
                infoRow(title: "URL", value: location.url)
                infoRow(title: "label_created".localized.uppercased(), value: location.created)
                
                if let location = viewModel.location, !location.residentIds.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("residents_section_title")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        FourColumnButtonGrid(items: location.residentIds) { characterId in
                            viewModel.handleResidentTap(characterId)
                        }
                        HStack {
                            Spacer()
                            Button("see_all_characters_button".localized.uppercased()) {
                                viewModel.handleSeeAllCharacters()
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
        value.isEmpty ? "generic_unknown".localized : value
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

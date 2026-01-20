//
//  CharacterDetailsView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct CharacterDetailsView: View {
    @State private var viewModel: CharacterDetailsViewModel

    init(viewModel: CharacterDetailsViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        contentView()
            .task {
                await viewModel.loadCharacterIfNeeded()
            }
            .navigationTitle("character_detail_title")
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
            if let character = viewModel.character {
                detailsView(character: character)
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

                infoRow(title: "label_gender".localized.uppercased(), value: character.gender)
                infoRow(title: "label_type".localized.uppercased(), value: character.type.isEmpty ? "generic_unknown".localizedCapitalized : character.type)
                infoRow(title: "label_origin".localized.uppercased(), value: character.origin.name)
                infoRow(title: "label_current_location".localized.uppercased(), value: character.location.name)

                if let character = viewModel.character {
                    if !character.episodeIds.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("episodes_section_title")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            FourColumnButtonGrid(items: character.episodeIds) { episodeId in
                                viewModel.handleEpisodeTap(episodeId)
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.handleSeeAllEpisodes()
                                }, label: {
                                    Text("see_all_episodes_button".localized.uppercased())
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                })
                            }
                        }
                    }
                    
                    if !character.locationIds.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("locations_section_title")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            FourColumnButtonGrid(items: character.locationIds) { locationId in
                                viewModel.handleLocationTap(locationId)
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.handleSeeAllLocations()
                                }, label: {
                                    Text("see_all_locations_button".localized.uppercased())
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                })
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
    }
}

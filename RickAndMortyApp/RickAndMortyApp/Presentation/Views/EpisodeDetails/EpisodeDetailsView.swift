//
//  EpisodeDetailsView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct EpisodeDetailsView: View {
    let episode: Episode

    var body: some View {
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
                infoRow(title: "Characters", value: "\(episode.characters.count)")
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

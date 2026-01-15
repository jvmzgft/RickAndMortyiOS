//
//  LocationDetailsView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct LocationDetailsView: View {
    let location: Location

    var body: some View {
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
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
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

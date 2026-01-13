//
//  CharacterDetailsView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct CharacterDetailsView: View {
    let character: Character

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: character.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        Color.gray.opacity(0.2)
                    } else {
                        ProgressView()
                    }
                }
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

                infoRow(title: "Gender", value: character.gender)
                infoRow(title: "Type", value: character.type.isEmpty ? "Unknown" : character.type)
                infoRow(title: "Origin", value: character.origin.name)
                infoRow(title: "Current location", value: character.location.name)
                infoRow(title: "Episodes", value: "\(character.episode.count)")
            }
            .padding()
        }
        .navigationTitle("Detail")
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

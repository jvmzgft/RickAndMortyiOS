//
//  FourColumnButtonGrid.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import SwiftUI

struct FourColumnButtonGrid: View {
    let items: [String]
    let action: (String) -> Void

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
            ForEach(items, id: \.self) { item in
                Button {
                    action(item)
                } label: {
                    Text(item)
                        .font(.footnote)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

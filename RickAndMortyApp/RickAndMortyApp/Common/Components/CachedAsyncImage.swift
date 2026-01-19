//
//  CachedAsyncImage.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import Kingfisher
import SwiftUI

struct CachedAsyncImage: View {
    private let url: URL?
    private let contentMode: SwiftUI.ContentMode
    private let showsProgress: Bool
    private let failureColor: Color

    @State private var didFail = false

    init(
        urlString: String,
        contentMode: SwiftUI.ContentMode = .fill,
        showsProgress: Bool = true,
        failureColor: Color = Color.gray.opacity(0.2)
    ) {
        self.url = URL(string: urlString)
        self.contentMode = contentMode
        self.showsProgress = showsProgress
        self.failureColor = failureColor
    }

    var body: some View {
        KFImage(url)
            .onFailure { _ in
                didFail = true
            }
            .placeholder {
                if didFail || !showsProgress {
                    failureColor
                } else {
                    ProgressView()
                }
            }
            .cacheOriginalImage()
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .onChange(of: url) { _, _ in
                didFail = false
            }
    }
}

//
//  GetEpisodeListUseCase.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

struct GetEpisodeListUseCase: UseCase {
    typealias Input = Int
    typealias Output = EpisodeListResponse

    private let repository: any HttpRepository

    init(repository: any HttpRepository) {
        self.repository = repository
    }

    func handle(_ input: Input) async throws -> Output {
        try await repository.fetchEpisodes(page: input)
    }
}

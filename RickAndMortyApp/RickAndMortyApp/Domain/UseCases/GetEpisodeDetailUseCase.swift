//
//  GetEpisodeDetailUseCase.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

struct GetEpisodeDetailUseCase: UseCase {
    typealias Input = String
    typealias Output = Episode

    private let repository: any HttpRepository

    init(repository: any HttpRepository) {
        self.repository = repository
    }

    func handle(_ input: Input) async throws -> Output {
        try await repository.fetchEpisode(id: input)
    }
}

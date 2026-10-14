//
//  GetLocationDetailUseCase.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

struct GetLocationDetailUseCase: UseCase {
    typealias Input = String
    typealias Output = Location

    private let repository: any HttpRepository

    init(repository: any HttpRepository) {
        self.repository = repository
    }

    func handle(_ input: Input) async throws -> Output {
        try await repository.fetchLocation(id: input)
    }
}

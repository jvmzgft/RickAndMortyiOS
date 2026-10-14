//
//  GetLocationListUseCase.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

struct GetLocationListUseCase: UseCase {
    typealias Input = Int
    typealias Output = LocationListResponse

    private let repository: any HttpRepository

    init(repository: any HttpRepository) {
        self.repository = repository
    }

    func handle(_ input: Input) async throws -> Output {
        try await repository.fetchLocations(page: input)
    }
}

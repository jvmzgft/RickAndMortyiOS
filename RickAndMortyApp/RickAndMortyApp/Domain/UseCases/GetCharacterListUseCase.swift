//
//  GetCharacterListUseCase.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

struct GetCharacterListUseCase: UseCase {
    struct Input {
        let page: Int
        let name: String?
    }

    typealias Output = CharacterListResponse

    private let repository: any HttpRepository

    init(repository: any HttpRepository) {
        self.repository = repository
    }

    func handle(_ input: Input) async throws -> Output {
        try await repository.fetchCharacters(page: input.page, name: input.name)
    }
}

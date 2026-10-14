//
//  UseCase.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 14/10/26.
//

protocol UseCase {
    associatedtype Input
    associatedtype Output

    func handle(_ input: Input) async throws -> Output
}

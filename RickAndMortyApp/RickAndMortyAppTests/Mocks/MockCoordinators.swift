//
//  MockCoordinators.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation
@testable import RickAndMortyApp

@MainActor
final class MockCharacterCoordinator: Coordinator, CharacterCoordinatorProtocol {
    private(set) var navigatedCharacter: Character?

    func navigateToDetail(character: Character) {
        navigatedCharacter = character
    }
}

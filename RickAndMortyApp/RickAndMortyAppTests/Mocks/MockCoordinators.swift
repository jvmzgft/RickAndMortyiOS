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
    private(set) var navigatedEpisodeId: String?
    private(set) var navigatedLocationId: String?
    private(set) var lastDeeplink: NavigationDestionation?

    func navigateToDetail(character: Character) {
        navigatedCharacter = character
    }

    func navigateToEpisodeDetail(id: String) {
        navigatedEpisodeId = id
    }

    func navigateToLocationDetail(id: String) {
        navigatedLocationId = id
    }

    func handleDeeplink(destination: NavigationDestionation) {
        lastDeeplink = destination
    }
}

@MainActor
final class MockEpisodesCoordinator: Coordinator, EpisodesCoordinatorProtocol {
    private(set) var navigatedEpisode: Episode?
    private(set) var navigatedCharacterId: String?
    private(set) var lastDeeplink: NavigationDestionation?

    func navigateToDetail(episode: Episode) {
        navigatedEpisode = episode
    }

    func navigateToCharacterDetail(id: String) {
        navigatedCharacterId = id
    }

    func handleDeeplink(destination: NavigationDestionation) {
        lastDeeplink = destination
    }
}

@MainActor
final class MockLocationsCoordinator: Coordinator, LocationsCoordinatorProtocol {
    private(set) var navigatedLocation: Location?
    private(set) var lastDeeplink: NavigationDestionation?

    func navigateToDetail(location: Location) {
        navigatedLocation = location
    }

    func handleDeeplink(destination: NavigationDestionation) {
        lastDeeplink = destination
    }
}

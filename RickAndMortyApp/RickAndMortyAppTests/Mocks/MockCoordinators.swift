//
//  MockCoordinators.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation
@testable import RickAndMortyApp

final class MockCharacterCoordinator: Coordinator, CharacterCoordinatorProtocol {
    private(set) var navigatedCharacter: Character?
    private(set) var navigatedEpisodeId: String?
    private(set) var navigatedLocationId: String?
    private(set) var lastDeeplink: NavigationDestionation?
    private(set) var lastDetailSpec: AppViewSpec?

    func navigateToDetail(character: Character) {
        navigatedCharacter = character
    }

    func navigateToEpisodeDetail(id: String) {
        navigatedEpisodeId = id
    }

    func navigateToLocationDetail(id: String) {
        navigatedLocationId = id
    }

    func navigateToDetail(_ spec: AppViewSpec) {
        lastDetailSpec = spec
    }

    func handleDeeplink(destination: NavigationDestionation) {
        lastDeeplink = destination
    }
}

final class MockEpisodesCoordinator: Coordinator, EpisodesCoordinatorProtocol {
    private(set) var navigatedEpisode: Episode?
    private(set) var navigatedCharacterId: String?
    private(set) var lastDeeplink: NavigationDestionation?
    private(set) var lastDetailSpec: AppViewSpec?

    func navigateToDetail(episode: Episode) {
        navigatedEpisode = episode
    }

    func navigateToDetail(_ spec: AppViewSpec) {
        lastDetailSpec = spec
    }

    func handleDeeplink(destination: NavigationDestionation) {
        lastDeeplink = destination
    }
}

final class MockLocationsCoordinator: Coordinator, LocationsCoordinatorProtocol {
    private(set) var navigatedLocation: Location?
    private(set) var lastDeeplink: NavigationDestionation?
    private(set) var lastDetailSpec: AppViewSpec?

    func navigateToDetail(location: Location) {
        navigatedLocation = location
    }

    func navigateToDetail(_ spec: AppViewSpec) {
        lastDetailSpec = spec
    }

    func handleDeeplink(destination: NavigationDestionation) {
        lastDeeplink = destination
    }
}

@MainActor
final class MockAppCoordinator: Coordinator, AppCoordinatorProtocol {
    private(set) var didNavigateToTabBar = false

    func navigateToTabBar() {
        didNavigateToTabBar = true
    }
}

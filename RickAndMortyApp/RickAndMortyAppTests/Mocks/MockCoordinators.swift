//
//  MockCoordinators.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation
@testable import RickAndMortyApp

@MainActor
final class MockCharacterCoordinator: Coordinator, NavigatingProtocol {
    var path: AppPath = AppPath()
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

    func navigateTo(_ spec: AppViewSpec) {
        lastDetailSpec = spec
    }

    func handleDeeplink(destination: NavigationDestionation) {
        lastDeeplink = destination
    }
}

@MainActor
final class MockEpisodesCoordinator: Coordinator, NavigatingProtocol {
    var path: AppPath = AppPath()
    private(set) var navigatedEpisode: Episode?
    private(set) var navigatedCharacterId: String?
    private(set) var lastDeeplink: NavigationDestionation?
    private(set) var lastDetailSpec: AppViewSpec?

    func navigateToDetail(episode: Episode) {
        navigatedEpisode = episode
    }

    func navigateTo(_ spec: AppViewSpec) {
        lastDetailSpec = spec
    }

    func handleDeeplink(destination: NavigationDestionation) {
        lastDeeplink = destination
    }
}

@MainActor
final class MockLocationsCoordinator: Coordinator, NavigatingProtocol {
    var path: AppPath = AppPath()
    private(set) var navigatedLocation: Location?
    private(set) var lastDeeplink: NavigationDestionation?
    private(set) var lastDetailSpec: AppViewSpec?

    func navigateToDetail(location: Location) {
        navigatedLocation = location
    }

    func navigateTo(_ spec: AppViewSpec) {
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

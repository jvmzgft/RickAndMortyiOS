//
//  CharacterDetailsViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class CharacterDetailsViewModelTests: XCTestCase {
    func testInitWithCharacterSetsReady() async {
        let coordinator = MockCharacterCoordinator()
        let character = makeCharacterWithEpisodesAndLocations()
        let viewModel = CharacterDetailsViewModel(character: character, coordinator: coordinator)

        XCTAssertEqual(viewModel.state, .ready)
        XCTAssertEqual(viewModel.character?.id, character.id)
    }

    func testLoadCharacterByIdSuccess() async {
        let mock = MockAPIClient()
        let character = makeCharacter(id: 7)
        mock.enqueue(.success(character))
        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterDetailsViewModel(id: "7", coordinator: coordinator, apiClient: mock)

        await viewModel.loadCharacterIfNeeded()

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.character?.id, 7)
        }
    }

    func testHandleEpisodeTapNavigates() async {
        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterDetailsViewModel(character: makeCharacter(id: 1), coordinator: coordinator)

        viewModel.handleEpisodeTap("12")

        XCTAssertEqual(coordinator.lastDetailSpec, .episodeDetail(nil, id: "12"))
    }

    func testHandleLocationTapNavigates() async {
        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterDetailsViewModel(character: makeCharacter(id: 1), coordinator: coordinator)

        viewModel.handleLocationTap("34")

        XCTAssertEqual(coordinator.lastDetailSpec, .locationDetail(nil, id: "34"))
    }

    func testHandleSeeAllEpisodesDeeplink() async {
        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterDetailsViewModel(character: makeCharacter(id: 1), coordinator: coordinator)

        viewModel.handleSeeAllEpisodes()

        XCTAssertEqual(coordinator.lastDeeplink, .episodes)
    }

    func testHandleSeeAllLocationsDeeplink() async {
        let coordinator = MockCharacterCoordinator()
        let viewModel = CharacterDetailsViewModel(character: makeCharacter(id: 1), coordinator: coordinator)

        viewModel.handleSeeAllLocations()

        XCTAssertEqual(coordinator.lastDeeplink, .locations)
    }
}

private func makeCharacterWithEpisodesAndLocations() -> Character {
    Character(
        id: 99,
        name: "Test Character",
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: CharacterLocation(name: "Origin", url: "https://example.com/location/1"),
        location: CharacterLocation(name: "Current", url: "https://example.com/location/2"),
        image: "https://example.com/image.png",
        episode: [
            "https://example.com/episode/1",
            "https://example.com/episode/2"
        ],
        url: "https://example.com/character/99",
        created: "2017-11-04T18:48:46.250Z"
    )
}

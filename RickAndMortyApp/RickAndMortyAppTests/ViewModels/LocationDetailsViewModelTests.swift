//
//  LocationDetailsViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class LocationDetailsViewModelTests: XCTestCase {
    
    func testInitWithLocationSetsReady() async {
        let coordinator = MockLocationsCoordinator()
        let location = makeLocation(id: 1)
        let viewModel = LocationDetailsViewModel(location: location, coordinator: coordinator)

        XCTAssertEqual(viewModel.state, .ready)
        XCTAssertEqual(viewModel.location?.id, 1)
    }

    func testLoadLocationByIdSuccess() async {
        let mock = MockAPIClient()
        let location = makeLocation(id: 9)
        mock.enqueue(.success(location))
        let coordinator = MockLocationsCoordinator()
        let viewModel = LocationDetailsViewModel(id: "9", coordinator: coordinator, apiClient: mock)

        await viewModel.loadLocationIfNeeded()

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.location?.id, 9)
        }
    }

    func testHandleResidentTapNavigates() async {
        let coordinator = MockLocationsCoordinator()
        let viewModel = LocationDetailsViewModel(location: makeLocation(id: 1), coordinator: coordinator)

        viewModel.handleResidentTap("12")

        XCTAssertEqual(coordinator.lastDetailSpec, .characterDetail(nil, id: "12"))
    }

    func testHandleSeeAllCharactersDeeplink() async {
        let coordinator = MockLocationsCoordinator()
        let viewModel = LocationDetailsViewModel(location: makeLocation(id: 1), coordinator: coordinator)

        viewModel.handleSeeAllCharacters()

        XCTAssertEqual(coordinator.lastDeeplink, .characters)
    }
}

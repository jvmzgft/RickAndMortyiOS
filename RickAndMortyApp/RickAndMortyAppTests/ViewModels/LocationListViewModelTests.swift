//
//  LocationListViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class LocationListViewModelTests: XCTestCase {
    func testLoadLocationsSuccess() async {
        let mock = MockHttpRepository()
        let response = LocationListResponse(
            info: PageInfo(count: 1, pages: 1, next: nil, prev: nil),
            results: [makeLocation(id: 1)]
        )
        mock.locationsResults.append(.success(response))

        let coordinator = MockLocationsCoordinator()
        let viewModel = LocationListViewModel(coordinator: coordinator, useCase: GetLocationListUseCase(repository: mock))

        await viewModel.loadLocations()

        await MainActor.run {
            XCTAssertEqual(viewModel.state, .ready)
            XCTAssertEqual(viewModel.locations.count, 1)
        }
        XCTAssertEqual(mock.operations, [.fetchLocations(page: 1)])
    }

    func testPaginationAppendsLocations() async {
        let mock = MockHttpRepository()
        let page1 = LocationListResponse(
            info: PageInfo(count: 2, pages: 2, next: "next", prev: nil),
            results: [makeLocation(id: 1)]
        )
        let page2 = LocationListResponse(
            info: PageInfo(count: 2, pages: 2, next: nil, prev: "prev"),
            results: [makeLocation(id: 2)]
        )
        mock.locationsResults = [.success(page1), .success(page2)]

        let coordinator = MockLocationsCoordinator()
        let viewModel = LocationListViewModel(coordinator: coordinator, useCase: GetLocationListUseCase(repository: mock))

        await viewModel.loadLocations()
        if let last = viewModel.locations.last {
            await viewModel.loadNextPageIfNeeded(currentItem: last)
        }

        await MainActor.run {
            XCTAssertEqual(viewModel.locations.count, 2)
            XCTAssertFalse(viewModel.isLoadingNextPage)
        }
        XCTAssertEqual(mock.operations, [.fetchLocations(page: 1), .fetchLocations(page: 2)])
    }

    func testSelectLocationNotifiesCoordinator() async {
        let mock = MockHttpRepository()
        let coordinator = MockLocationsCoordinator()
        let viewModel = LocationListViewModel(coordinator: coordinator, useCase: GetLocationListUseCase(repository: mock))
        let location = makeLocation(id: 10)

        viewModel.selectLocation(location)

        await MainActor.run {
            XCTAssertEqual(coordinator.lastDetailSpec, .locationDetail(location, id: nil))
        }
        XCTAssertTrue(mock.operations.isEmpty)
    }
}

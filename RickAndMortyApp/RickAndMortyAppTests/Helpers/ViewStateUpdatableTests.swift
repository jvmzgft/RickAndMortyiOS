//
//  ViewStateUpdatableTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class ViewStateUpdatableTests: XCTestCase {
    func testUpdateViewStateChangesStateOnMainActor() async {
        let updater = StateUpdater()
        XCTAssertEqual(updater.state, .loading)

        await updater.updateViewState(.ready)

        await MainActor.run {
            XCTAssertEqual(updater.state, .ready)
        }
    }
}

private final class StateUpdater: ViewStateUpdatable {
    var state: ViewState = .loading
}

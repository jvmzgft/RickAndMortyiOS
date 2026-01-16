//
//  SplashViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class SplashViewModelTests: XCTestCase {
    func testGoToTabBarNotifiesCoordinator() async {
        let coordinator = MockAppCoordinator()
        let viewModel = SplashViewModel(splashLottie: "rick.json", coordinator: coordinator)

        viewModel.goToTabBar()

        XCTAssertTrue(coordinator.didNavigateToTabBar)
    }
}

//
//  RickAndMortyAppUITests.swift
//  RickAndMortyAppUITests
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import XCTest

final class RickAndMortyAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testNavigationSmoke() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()

        let charactersTab = app.tabBars.buttons["Characters"]
        XCTAssertTrue(charactersTab.waitForExistence(timeout: 30))
        XCTAssertTrue(app.navigationBars["Characters"].exists)

        let character = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH %@", "Rick Sanchez")
        ).firstMatch
        XCTAssertTrue(character.waitForExistence(timeout: 30))
        character.tap()

        let detail = app.navigationBars["Character detail"]
        XCTAssertTrue(detail.waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Rick Sanchez"].exists)
        detail.buttons.firstMatch.tap()
        XCTAssertTrue(app.navigationBars["Characters"].waitForExistence(timeout: 10))

        app.tabBars.buttons["Episodes"].tap()
        XCTAssertTrue(app.navigationBars["Episodes"].waitForExistence(timeout: 10))

        app.tabBars.buttons["Locations"].tap()
        XCTAssertTrue(app.navigationBars["Locations"].waitForExistence(timeout: 10))

        app.tabBars.buttons["Search"].tap()
        XCTAssertTrue(app.searchFields.firstMatch.waitForExistence(timeout: 10))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}

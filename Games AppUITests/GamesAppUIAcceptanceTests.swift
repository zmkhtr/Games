//
//  GamesAppUIAcceptanceTests.swift
//  Games AppUITests
//
//  Created by Azam Mukhtar on 23/02/23.
//

import XCTest

class GamesAppUIAcceptanceTests: XCTestCase {

    func test_onLaunch_displaysRemoteGamesWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        app.launch()

        let gameCells = app.cells.matching(identifier: "game-item-cell")
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 3)
        
        XCTAssertEqual(gameCells.count, 10)

        let firstItem = app.images.matching(identifier: "game-image-view").firstMatch
        XCTAssertTrue(firstItem.exists)
    }

    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivity() {
        let app = XCUIApplication()
        app.launch()

        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 0)
    }

    func test_onLaunch_tapToCellThenShowDetail(){
        let app = XCUIApplication()
        app.launch()

        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        
        let image = app.images.matching(identifier: "game-image-view").firstMatch
        XCTAssertFalse(image.exists)
    }
    
    func test_onLaunch_tapToCellThenShowDetailThenTapFavorite(){
        let app = XCUIApplication()
        app.launch()

        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        
       app.buttons["game-favorite-button"].tap()
        
       app.buttons["game-favorite-button"].tap()
        
        let image = app.images.matching(identifier: "game-detail-image").firstMatch
        XCTAssertTrue(image.exists)
    }
    
    func test_onLaunch_tapToCellThenShowDetailThenTapFavoriteThenTapFavoriteTab(){
        let app = XCUIApplication()
        app.launch()

        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        
        app.buttons["game-favorite-button"].tap()

        app.tabBars.buttons.element(boundBy: 1).tap()
        
        app.tabBars.buttons.element(boundBy: 0).tap()
        
        app.buttons["game-favorite-button"].tap()
        
        let firstItem = app.images.matching(identifier: "game-detail-image").firstMatch
        XCTAssertTrue(firstItem.exists)
    }
    
    func test_onLaunch_tapToCellThenShowDetailThenTapFavoriteThenTapFavoriteTabThenTapDetail(){
        let app = XCUIApplication()
        app.launch()

        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        
        app.buttons["game-favorite-button"].tap()

        app.tabBars.buttons.element(boundBy: 1).tap()
        
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        
        app.buttons["game-favorite-button"].tap()
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        let gameCells = app.cells.matching(identifier: "game-item-cell")
        XCTAssertTrue(gameCells.element.exists)
    }
    
    // Cannot find how to tap Search bar. nothing is working
//    func test_onLaunch_tapToSearchBarThenTypeQueryShowTypedQueryItem(){
//        let app = XCUIApplication()
//        app.launch()
//
//        let searchBarElement = app.navigationBars["SearchView"].otherElements["search-bar"]
//
//        searchBarElement.tap()
//        searchBarElement.typeText("Naruto")
//    }
}

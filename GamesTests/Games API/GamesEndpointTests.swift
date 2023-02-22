//
//  GamesEndpointTests.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import XCTest
import Games

class GamesEndpointTests: XCTestCase {
    
    func test_games_endpointURL() {
        let baseURL = URL(string: "https://base-url.com/api/games")!
        
        let request = GamesRequest(page: 1, page_size: 10)
        let received = GamesEndpoint.get(request: request).url(baseURL: baseURL)
        
        XCTAssertEqual(received.url?.scheme, "https", "scheme")
        XCTAssertEqual(received.url?.host, "base-url.com", "host")
        XCTAssertEqual(received.url?.path, "/api/games", "path")
    }
    
    func test_games_endpointURLForGivenPageAndSize() {
        let baseURL = URL(string: "https://base-url.com/api/games")!
        
        let page = 43
        let pageSize = 10
        let request = GamesRequest(page: page, page_size: pageSize)
        let received = GamesEndpoint.get(request: request).url(baseURL: baseURL)
        
        XCTAssertEqual(received.url?.scheme, "https", "scheme")
        XCTAssertEqual(received.url?.host, "base-url.com", "host")
        XCTAssertEqual(received.url?.path, "/api/games", "path")
        XCTAssertEqual(received.url?.query?.contains("page_size=\(pageSize)"), true, "page size query param")
        XCTAssertEqual(received.url?.query?.contains("page=\(page)"), true, "page query param")
    }
    
    func test_game_endpointURLForGivenSearchQuery() {
        let baseURL = URL(string: "https://base-url.com/api/games")!
        
        let page = 43
        let pageSize = 10
        let query = "naruto"
        let request = GamesRequest(page: page, page_size: pageSize, search: query)
        let received = GamesEndpoint.get(request: request).url(baseURL: baseURL)
        
        XCTAssertEqual(received.url?.scheme, "https", "scheme")
        XCTAssertEqual(received.url?.host, "base-url.com", "host")
        XCTAssertEqual(received.url?.path, "/api/games", "path")
        XCTAssertEqual(received.url?.query?.contains("page_size=\(pageSize)"), true, "page size query param")
        XCTAssertEqual(received.url?.query?.contains("page=\(page)"), true, "page query param")
        XCTAssertEqual(received.url?.query?.contains("search=\(query)"), true, "page query param")
    }
}


//
//  Game Detail Endpoint.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import XCTest
import Games

class GamesDetailEndpointTests: XCTestCase {
    
    func test_game_detail_endpointURL() {
        let baseURL = URL(string: "https://base-url.com/api/games")!
        let gameID = 3342
        
        let received = GameDetailEndpoint.get(id: gameID).url(baseURL: baseURL)
        
        XCTAssertEqual(received.url?.scheme, "https", "scheme")
        XCTAssertEqual(received.url?.host, "base-url.com", "host")
        XCTAssertEqual(received.url?.path, "/api/games/\(gameID)", "path")
    }
    
}


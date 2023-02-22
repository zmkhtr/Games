//
//  GamesItemsMapperTests.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import XCTest
import Games

class GamesItemsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try GamesItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try GamesItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try GamesItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: 2343, title: "GTA", releaseDate: "2013-09-17", rating: 4.7, image: anyURL())
        let item2 = makeItem(id: 8345, title: "The Witcher", releaseDate: "2010-02-17", rating: 4.9, image: anyURL())
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try GamesItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // - MARK: Helpers

    private func makeItem(id: Int, title: String, releaseDate: String, rating: Double, image: URL) -> (model: GameItem, json: [String: Any]) {
        let item = GameItem(id: id, title: title, releaseDate: releaseDate, rating: rating, image: image)
        
        let json = [
            "id": id,
            "name": "\(title)",
            "released": "\(releaseDate)",
            "rating": rating,
            "background_image": "\(image.absoluteString)"
        ].compactMapValues { $0 }
        
        return (item, json)
    }
}

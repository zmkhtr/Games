//
//  GameDetailItemMapperTests.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import XCTest
import Games

class GameDetailItemsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try GameDetailItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try GameDetailItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: 2342, title: "GTA", releaseDate: "2013-09-17", rating: 3.5, image: anyURL(), description: "any description", played: 93, developer: "Rockstart", isFavorite: false)
        
        
        let result = try GameDetailItemsMapper.map(item1.data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, item1.model)
    }

    
    func makeItem(id: Int, title: String, releaseDate: String, rating: Double, image: URL, description: String, played: Int, developer: String, isFavorite: Bool) -> (model: GameDetailItem, data: Data) {
        let item = GameDetailItem(id: id, title: title, releaseDate: releaseDate, rating: rating, image: image, description: description, played: played, developers: developer, isFavorite: isFavorite)
        
        let json = [
            "id": id,
            "name": "\(title)",
            "released": "\(releaseDate)",
            "rating": rating,
            "description": description,
            "background_image": "\(image.absoluteString)",
            "added_by_status": [
                "player": played
            ],
            "developers": [
                [
                    "name": developer
                ]
            ]
        ].compactMapValues { $0 }
        let data = try! JSONSerialization.data(withJSONObject: json)
        return (item, data)
    }

}

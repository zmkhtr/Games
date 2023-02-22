//
//  GamesItemsMapperTests.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import XCTest
import Games


public final class GamesItemsMapper {

    private struct Root: Decodable {
        let results: [Result]
        
        struct Result: Decodable {
            let name: String
            let released: String
            let background_image: URL
            let rating: Double
            let id: Int
        }
        
        var items: [GameItem] {
            results.map { result in
                GameItem(
                    id: result.id,
                    title: result.name,
                    releaseDate: result.released,
                    rating: result.rating,
                    image: result.background_image)
            }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [GameItem] {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        
        return root.items
    }
}


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
    
    // MARK: - Helpers
    
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
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["results": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }

}

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

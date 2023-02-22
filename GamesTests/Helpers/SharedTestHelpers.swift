//
//  SharedTestHelpers.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation
import Games

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func makeItem(id: Int, title: String, releaseDate: String, rating: Double, image: URL) -> (model: GameItem, json: [String: Any]) {
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

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["results": items]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

//
//  GamesItemsMapper.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public final class GamesItemsMapper {

    private struct Root: Decodable {
        let results: [Result]
        
        struct Result: Decodable {
            let name: String
            let released: String?
            let background_image: URL?
            let rating: Double
            let id: Int
        }
        
        var items: [GameItem] {
            results.map { result in
                GameItem(
                    id: result.id,
                    title: result.name,
                    releaseDate: result.released ?? "Unknown",
                    rating: result.rating,
                    image: result.background_image)
            }
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [GameItem] {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteGamesLoader.Error.invalidData
        }
        
        
        return root.items
    }
}

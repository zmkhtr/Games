//
//  GameDetailItemsMapper.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public final class GameDetailItemsMapper {

    private struct Root: Decodable {
        let id: Int
        let name: String
        let description: String
        let rating: Double
        let released: String
        let added_by_status: AddedByStatus
        let developers: [Developer]
        let background_image: URL
        
        struct AddedByStatus: Decodable {
            let playing: Int
        }
        
        struct Developer: Decodable {
            let name: String
        }
        
        var item: GameDetailItem {
           GameDetailItem(
            id: id,
            title: name,
            releaseDate: released,
            rating: rating,
            image: background_image,
            description: description,
            played: added_by_status.playing,
            developers: developers.first?.name ?? "Unknown",
            isFavorite: false)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> GameDetailItem {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteGamesLoader.Error.invalidData
        }
        
        
        return root.item
    }
}

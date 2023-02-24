//
//  GameDetailItem.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public struct GameDetailItem: Hashable {
    public let id: Int
    public let title: String
    public let releaseDate: String
    public let rating: Double
    public let image: URL?
    public let description: String
    public let played: Int
    public let developers: String
    public var isFavorite: Bool
    
    public init(id: Int, title: String, releaseDate: String, rating: Double, image: URL?, description: String, played: Int, developers: String, isFavorite: Bool) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.rating = rating
        self.image = image
        self.description = description
        self.played = played
        self.developers = developers
        self.isFavorite = isFavorite
    }
}

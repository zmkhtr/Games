//
//  GameItem.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public struct GameItem: Hashable {
    public let id: Int
    public let title: String
    public let releaseDate: String
    public let rating: Double
    public let image: URL?
    
    public init(id: Int, title: String, releaseDate: String, rating: Double, image: URL?) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.rating = rating
        self.image = image
    }
}

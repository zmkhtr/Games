//
//  CDGameDetail.swift
//  Games
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import CoreData

@objc(CDGameDetail)
class CDGameDetail: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var title: String
    @NSManaged var releaseDate: String
    @NSManaged var rating: Double
    @NSManaged var image: URL?
    @NSManaged var gameDescription: String
    @NSManaged var played: Int
    @NSManaged var developers: String
    @NSManaged var isFavorite: Bool
}

extension CDGameDetail {
    static func first(with id: Int, in context: NSManagedObjectContext) throws -> CDGameDetail? {
        let request = NSFetchRequest<CDGameDetail>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(CDGameDetail.id), id])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func getAllData(in context: NSManagedObjectContext) throws -> [CDGameDetail]? {
        let request = NSFetchRequest<CDGameDetail>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    static func game(from game: GameDetailItem, in context: NSManagedObjectContext) {
        let managed = CDGameDetail(context: context)
        managed.id = game.id
        managed.title = game.title
        managed.releaseDate = game.releaseDate
        managed.rating = game.rating
        managed.image = game.image
        managed.gameDescription = game.description
        managed.played = game.played
        managed.developers = game.developers
        managed.isFavorite = game.isFavorite
    }
}

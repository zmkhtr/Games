//
//  CDImageData.swift
//  Games
//
//  Created by Azam Mukhtar on 23/02/23.
//

import CoreData

@objc(CDImageData)
class CDImageData: NSManagedObject {
    @NSManaged var url: URL
    @NSManaged var data: Data?
}

extension CDImageData {
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> CDImageData? {
        let request = NSFetchRequest<CDImageData>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(CDImageData.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func image(from local: LocalImageData, in context: NSManagedObjectContext) {
        let managed = CDImageData(context: context)
        managed.url = local.url
        managed.data = local.data
    }
}

//
//  CoreDataImageDataStore.swift
//  Games
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import CoreData

public final class CoreDataImageDataStore {
    private static let modelName = "ImageData"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataImageDataStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataImageDataStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(modelName: "ImageData", model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}

extension CoreDataImageDataStore: ImageDataStore {

    public func insert(_ data: LocalImageData, completion: @escaping (ImageDataStore.InsertionResult) -> Void) {
        perform { context in
            if let existingObject = try? CDImageData.first(with: data.url, in: context) {
                context.delete(existingObject)
            }
            completion(Result {
                CDImageData.image(from: data, in: context)
                try context.save()
            })
        }
        
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (ImageDataStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try CDImageData.first(with: url, in: context)?.data
            })
        }
    }
    
}


//
//  CoreDataGameDetailStore.swift
//  Games
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import CoreData

public final class CoreDataGameDetailStore {
    private static let modelName = "GameDetail"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataGameDetailStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataGameDetailStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(modelName: "GameDetail", model: model, url: storeURL)
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

extension CoreDataGameDetailStore: GameDetailStore {
    public func delete(dataForID id: Int, completion: @escaping (DeletionResult) -> Void) {
        perform { context in
            completion(Result {
                try CDGameDetail.first(with: id, in: context).map(context.delete(_:))
            })
        }
    }
    

    public func insert(_ game: GameDetailItem, completion: @escaping (GameDetailStore.InsertionResult) -> Void) {
        perform { context in
            if let existingObject = try? CDGameDetail.first(with: game.id, in: context) {
                context.delete(existingObject)
            }
            completion(Result {
                CDGameDetail.game(from: game, in: context)
                try context.save()
            })
        }
    }
    
    
    public func retrieve(dataForID id: Int, completion: @escaping (GameDetailStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try CDGameDetail.first(with: id, in: context).map {
                    GameDetailItem(
                        id: $0.id,
                        title: $0.title,
                        releaseDate: $0.releaseDate,
                        rating: $0.rating,
                        image: $0.image,
                        description: $0.gameDescription,
                        played: $0.played,
                        developers: $0.developers,
                        isFavorite: $0.isFavorite)
                }
            })
        }
    }
    
    public func getAllData(completion: @escaping (AllResult) -> Void) {
        perform { context in
            completion(Result {
                try CDGameDetail.getAllData(in: context)?.map({
                    GameDetailItem(
                        id: $0.id,
                        title: $0.title,
                        releaseDate: $0.releaseDate,
                        rating: $0.rating,
                        image: $0.image,
                        description: $0.gameDescription,
                        played: $0.played,
                        developers: $0.developers,
                        isFavorite: $0.isFavorite)
                })
            })
        }
    }
}


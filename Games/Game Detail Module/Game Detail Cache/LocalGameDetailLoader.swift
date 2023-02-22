//
//  LocalGameDetailLoader.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public final class LocalGameDetailLoader {
    private let store: GameDetailStore
    
    public init(store: GameDetailStore) {
        self.store = store
    }
}

extension LocalGameDetailLoader: GameDetailLoader {
    public enum LoadError: Error {
        case failed
        case notFound
    }
        
    public func get(for id: Int, completion: @escaping (GameDetailLoader.Result) -> Void) {
        store.retrieve(dataForID: id) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(game):
                if let game = game {
                    completion(.success(game))
                } else {
                    completion(.failure(LoadError.notFound))
                }
            case .failure:
                completion(.failure(LoadError.failed))
            }
        }
    }
}

extension LocalGameDetailLoader: GameDetailCache {
    public enum SaveError: Error {
        case failed
    }
    
    public func save(_ game: GameDetailItem, completion: @escaping (GameDetailCache.Result) -> Void) {
        store.insert(game) { [weak self] result in
            guard self != nil else { return }
            
            completion(result.mapError { _ in SaveError.failed } )
        }
    }
}

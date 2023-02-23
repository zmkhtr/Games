//
//  GameDetailLoaderWithCacheDecorator.swift
//  Games App
//
//  Created by Azam Mukhtar on 24/02/23.
//

import Foundation
import Games

final class GameDetailLoaderWithCacheDecorator: GameDetailLoader {
    private let decoratee: GameDetailLoader
    private let cache: GameDetailCache
    
    init(decoratee: GameDetailLoader, cache: GameDetailCache){
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func get(for id: Int, completion: @escaping (GameDetailLoader.Result) -> Void) {
        decoratee.get(for: id) { [weak self] result in
            completion(result.map { game in
                self?.cache.saveIgnoringResult(game)
                return game
            })
        }
    }
}

private extension GameDetailCache {
    func saveIgnoringResult(_ game: GameDetailItem) {
        save(game) { _ in }
    }
}

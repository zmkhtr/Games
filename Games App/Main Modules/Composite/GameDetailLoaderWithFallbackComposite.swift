//
//  GameDetailLoaderWithFallbackComposite.swift
//  Games App
//
//  Created by Azam Mukhtar on 24/02/23.
//

import Foundation
import Games

public class GameDetailLoaderWithFallbackComposite: GameDetailLoader {
    private let primary: GameDetailLoader
    private let fallback: GameDetailLoader
    
    init(primary: GameDetailLoader, fallback: GameDetailLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    
    public func get(for id: Int, completion: @escaping (GameDetailLoader.Result) -> Void) {
        primary.get(for: id) { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                self?.fallback.get(for: id, completion: completion)
            }
        }
    }
}




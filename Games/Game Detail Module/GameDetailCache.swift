//
//  GameDetailCache.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public protocol GameDetailCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ game: GameDetailItem, completion: @escaping (Result) -> Void)
}

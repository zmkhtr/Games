//
//  GameDetailStore.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public protocol GameDetailStore {
    typealias RetrievalResult = Swift.Result<GameDetailItem?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(_ game: GameDetailItem, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForID id: Int, completion: @escaping (RetrievalResult) -> Void)
}

//
//  GameDataStoreSpy.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation
import Games

class GameDataStoreSpy: GameDetailStore {

    enum Message: Equatable {
        case insert(game: GameDetailItem, for: Int)
        case retrieve(dataFor: Int)
    }
    
    private(set) var receivedMessages = [Message]()
    private var retrievalCompletions = [(GameDetailStore.RetrievalResult) -> Void]()
    private var insertionCompletions = [(GameDetailStore.InsertionResult) -> Void]()

    func insert(_ game: GameDetailItem, completion: @escaping (InsertionResult) -> Void) {
        receivedMessages.append(.insert(game: game, for: game.id))
        insertionCompletions.append(completion)
    }
    
    func retrieve(dataForID id: Int, completion: @escaping (GameDetailStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: id))
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with game: GameDetailItem?, at index: Int = 0) {
        retrievalCompletions[index](.success(game))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
}

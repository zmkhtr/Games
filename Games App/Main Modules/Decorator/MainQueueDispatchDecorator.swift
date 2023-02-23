//
//  MainQueueDispatchDecorator.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

public final class MainQueueDispatchDecorator<T> {

  private(set) public var decoratee: T

  public init(decoratee: T) {
    self.decoratee = decoratee
  }

  public func dispatch(completion: @escaping () -> Void) {
    guard Thread.isMainThread else {
      return DispatchQueue.main.async(execute: completion)
    }

    completion()
  }
}

extension MainQueueDispatchDecorator: GamesLoader where T == GamesLoader {
    
    public func load(request: GamesRequest, completion: @escaping (GamesLoader.Result) -> Void) {
        decoratee.load(request: request) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: ImageDataLoader where T == ImageDataLoader {
    
    public func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: GameDetailLoader where T == GameDetailLoader {
    
    public func get(for id: Int, completion: @escaping (GameDetailLoader.Result) -> Void) {
        decoratee.get(for: id) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: GameDetailCache where T == GameDetailCache {
    
    public func save(_ game: GameDetailItem, completion: @escaping (GameDetailCache.Result) -> Void) {
        decoratee.save(game) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}




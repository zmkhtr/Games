//
//  LocalImageDataLoader.swift
//  Games
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation

public final class LocalImageDataLoader: ImageDataLoader {
    
    private let store: ImageDataStore
    
    public init(store: ImageDataStore) {
        self.store = store
    }
    
    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    public typealias LoadResult = ImageDataLoader.Result
    
    private final class Task: ImageDataLoaderTask {
        private var completion: ((ImageDataLoader.Result) -> Void)?
        
        init(_ completion: @escaping (ImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: ImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
        let task = Task(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                            .mapError { _ in LoadError.failed}
                            .flatMap { data in
                data.map { .success($0) } ?? .failure(LoadError.notFound)
            })
        }
        return task
    }
}

extension LocalImageDataLoader: ImageDataCache {
    
    public typealias SaveResult = ImageDataCache.Result
    
    public enum SaveError: Swift.Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        let localImage = LocalImageData(url: url, data: data)
        store.insert(localImage) { [weak self] result in
            guard self != nil else { return }
            
            completion(result.mapError { _ in SaveError.failed } )
        }
    }
}

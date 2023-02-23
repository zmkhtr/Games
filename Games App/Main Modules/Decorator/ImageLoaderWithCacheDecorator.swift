//
//  ImageLoaderWithCacheDecorator.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

final class ImageLoaderWithCacheDecorator: ImageDataLoader {
    private let decoratee: ImageDataLoader
    private let cache: ImageDataCache
    
    init(decoratee: ImageDataLoader, cache: ImageDataCache){
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.cache.saveIgnoringResult(LocalImageData(url: url, data: data))
                return data
            })
        }
    }
}

private extension ImageDataCache {
    func saveIgnoringResult(_ data: LocalImageData) {
        save(data.data!, for: data.url) { _ in }
    }
}

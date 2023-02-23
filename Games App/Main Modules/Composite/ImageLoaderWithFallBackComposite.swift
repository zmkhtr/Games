//
//  ImageLoaderWithFallBackComposite.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

public class ImageLoaderWithFallBackComposite: ImageDataLoader {
    private let primary: ImageDataLoader
    private let fallback: ImageDataLoader
    
    init(primary: ImageDataLoader, fallback: ImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    
    private class TaskWrapper: ImageDataLoaderTask {
        var wrapped: ImageDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    
    public func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primary.loadImageData(from: url) {  [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                task.wrapped = self?.fallback.loadImageData(from: url, completion: completion)
            }
        }
        return task
    }
}




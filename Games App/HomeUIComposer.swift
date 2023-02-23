//
//  HomeUIComposer.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

final class HomeUIComposer {
    private init() {}
    
    public static func homeComposedWith(
        gamesLoader: GamesLoader,
        imageLoader: ImageDataLoader
    ) -> HomeViewController {
        
        let viewModel = HomeViewModel(
            gamesLoader: MainQueueDispatchDecorator(decoratee: gamesLoader),
            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader))
                
        return HomeViewController(viewModel: viewModel)
    }
}

//class NullStore {}
//
//extension NullStore: ImageDataStore {
//    func deleteCachedFeed() throws {}
//
//    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {}
//
//    func retrieve() throws -> CachedFeed? { .none }
//}
//
//extension NullStore: FeedImageDataStore {
//    func insert(_ data: Data, for url: URL) throws {}
//
//    func retrieve(dataForURL url: URL) throws -> Data? { .none }
//}

import CoreData

final class HomeUIFactory {
    
    private static var store: ImageDataStore = {
        try! CoreDataImageDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("image-store.sqlite"))
    }()
    
    
    public static func create() -> HomeViewController {
        let session = URLSession(configuration: .default)
        let httpClient = URLSessionHTTPClient(session: session)
        let authHTTPClient = AuthenticatedHTTPClientDecorator(decoratee: httpClient)
        let gamesLoader = RemoteGamesLoader(url: URL(string: "https://api.rawg.io/api/games")!, client: authHTTPClient)
        
        let imageCache = LocalImageDataLoader(store: store)
        let remoteImageLoader = RemoteImageDataLoader(client: httpClient)
        let imageCacheDecorator = ImageLoaderWithCacheDecorator(
            decoratee: remoteImageLoader,
            cache: imageCache)
        let imageFallback = ImageLoaderWithFallBackComposite(
            primary: imageCache,
            fallback: imageCacheDecorator)
        
        return HomeUIComposer.homeComposedWith(gamesLoader: gamesLoader, imageLoader: imageFallback)
    }
}

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



class AuthenticatedHTTPClientDecorator: HTTPClient {

    private let decoratee: HTTPClient

    init(decoratee: HTTPClient) {
        self.decoratee = decoratee
    }
    
    func request(from request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> Games.HTTPClientTask {
        decoratee.request(from: enrich(request), completion: completion)
    }
    
    private func enrich(_ request: URLRequest) -> URLRequest {
        var request = request
        request.url?.append(queryItems: [
            URLQueryItem(name: "key", value: "375107cb63db476a86598ff9936da3c4")
        ])
    
        return request
       
    }
}

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


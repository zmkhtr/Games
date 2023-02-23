//
//  HomeUIFactory.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

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

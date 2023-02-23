//
//  HomeUIFactory.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

final class HomeUIFactory {
    
    public static func create(
        httpClient: HTTPClient,
        imageStore: ImageDataStore,
        onGameSelected: @escaping ((Int) -> Void)
    ) -> HomeViewController {
       
        let gamesLoader = RemoteGamesLoader(url: URL(string: "https://api.rawg.io/api/games")!, client: httpClient)
        
        let imageCache = LocalImageDataLoader(store: imageStore)
        let remoteImageLoader = RemoteImageDataLoader(client: httpClient)
        let imageCacheDecorator = ImageLoaderWithCacheDecorator(
            decoratee: remoteImageLoader,
            cache: imageCache)
        let imageFallback = ImageLoaderWithFallBackComposite(
            primary: imageCache,
            fallback: imageCacheDecorator)
        
        return HomeUIComposer.homeComposedWith(gamesLoader: gamesLoader, imageLoader: imageFallback, onGameSelected: onGameSelected)
    }
}

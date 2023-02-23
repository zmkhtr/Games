//
//  DetailUIFactory.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

final class DetailUIFactory {
    
    public static func create(
        id: Int,
        gameStore: GameDetailStore,
        imageLoader: ImageDataLoader,
        httpClient: HTTPClient,
        baseURL: URL
    ) -> DetailViewController {
        
        let gameLoader = LocalGameDetailLoader(store: gameStore)
        let remote = RemoteGameDetailLoader(url: baseURL, client: httpClient)
        let cacheDecorator = GameDetailLoaderWithCacheDecorator(decoratee: remote, cache: gameLoader)
        let fallback = GameDetailLoaderWithFallbackComposite(primary: gameLoader, fallback: cacheDecorator)
        
        return DetailUIComposer.detailComposedWith(id: id, gameLoader: fallback, imageLoader: imageLoader, gameCache: gameLoader)
    }
}

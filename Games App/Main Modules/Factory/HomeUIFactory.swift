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
        imageLoader: ImageDataLoader,
        baseURL: URL,
        onGameSelected: @escaping ((Int) -> Void)
    ) -> HomeViewController {
       
        let gamesLoader = RemoteGamesLoader(url: baseURL, client: httpClient)
        
        return HomeUIComposer.homeComposedWith(gamesLoader: gamesLoader, imageLoader: imageLoader, onGameSelected: onGameSelected)
    }
}

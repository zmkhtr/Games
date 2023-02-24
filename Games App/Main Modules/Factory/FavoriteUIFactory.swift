//
//  FavoriteUIFactory.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

final class FavoriteUIFactory {
    
    public static func create(
        imageLoader: ImageDataLoader,
        gameStore: GameDetailStore,
        onGameSelected: @escaping ((Int) -> Void)
    ) -> FavoriteListViewController {
       
        let gamesLoader = LocalGameDetailLoader(store: gameStore)
        
        return FavoriteUIComposer.favoriteComposedWith(gamesLoader: gamesLoader, imageLoader: imageLoader, onGameSelected: onGameSelected)
    }
}

//
//  FavoriteUIComposer.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games


final class FavoriteUIComposer {
    private init() {}
    
    public static func favoriteComposedWith(
        gamesLoader: AllGamesDetailLoader,
        imageLoader: ImageDataLoader,
        onGameSelected: @escaping ((Int) -> Void)
    ) -> FavoriteListViewController {
        
        let viewModel = FavoriteViewModel(
            gamesLoader: MainQueueDispatchDecorator(decoratee: gamesLoader),
            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader))
                
        return FavoriteListViewController(viewModel: viewModel, onGameSelected: onGameSelected)
    }
}




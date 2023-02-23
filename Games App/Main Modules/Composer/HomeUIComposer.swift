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




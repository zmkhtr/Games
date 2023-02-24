//
//  HomeUIComposer.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

final public class HomeUIComposer {
    private init() {}
    
    public static func homeComposedWith(
        gamesLoader: GamesLoader,
        imageLoader: ImageDataLoader,
        onGameSelected: @escaping ((Int) -> Void)
    ) -> HomeViewController {
        
        let viewModel = HomeViewModel(
            gamesLoader: MainQueueDispatchDecorator(decoratee: gamesLoader),
            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader))
                
        let homeVC = HomeViewController(viewModel: viewModel, onGameSelected: onGameSelected)
        homeVC.title = "Games For You"
        return homeVC
    }
}




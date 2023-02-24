//
//  DetailUIComposer.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

final class DetailUIComposer {
    private init() {}
    
    public static func detailComposedWith(
        id: Int,
        gameLoader: GameDetailLoader,
        imageLoader: ImageDataLoader,
        gameCache: GameDetailCache
    ) -> DetailViewController {
        
        let viewModel = DetailViewModel(
            id: id,
            gameLoader:         MainQueueDispatchDecorator(decoratee: gameLoader),
            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader),
            gameCache: MainQueueDispatchDecorator(decoratee: gameCache))
        
        
        
        return DetailViewController(viewModel: viewModel)
    }
}

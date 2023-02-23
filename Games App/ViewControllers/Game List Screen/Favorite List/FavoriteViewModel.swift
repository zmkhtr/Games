//
//  FavoriteViewModel.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

final class FavoriteViewModel {
    typealias Observer<T> = (T) -> Void

    private let gamesLoader: AllGamesDetailLoader
    private let imageLoader: ImageDataLoader

    public init(gamesLoader: AllGamesDetailLoader, imageLoader: ImageDataLoader) {
        self.gamesLoader = gamesLoader
        self.imageLoader = imageLoader
    }

    var onLoadingStateChange: Observer<Bool>?
    var onErrorStateChange: Observer<String?>?
    var onGamesLoad: Observer<[GameCellController]>?

    private var isLoading = false
    
    func loadGames() {
        onLoadingStateChange?(true)
        onErrorStateChange?(nil)
        isLoading = true
        
        gamesLoader.getAll { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStateChange?(false)
            self.isLoading = false

            switch result {
            case let .success(games):
                self.onGamesLoad?(self.map(games: games))
            case .failure:
                self.onErrorStateChange?("Error Fetching Data")
            }
        }
    }

    private func map(games: [GameDetailItem]) -> [GameCellController] {
        var controller: [GameCellController] = []
        
        for game in games {
            if game.isFavorite {
                let gameItem = GameItem(id: game.id, title: game.title, releaseDate: game.releaseDate, rating: game.rating, image: game.image)
                
                let gameCellViewModel = GameCellViewModel(model: gameItem, imageLoader: self.imageLoader)
                controller.append(GameCellController(viewModel: gameCellViewModel))
            }
        }
        
        return controller
    }
}

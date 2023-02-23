//
//  HomeViewModel.swift
//  GameUI
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

final class HomeViewModel {
    typealias Observer<T> = (T) -> Void

    private let gamesLoader: GamesLoader
    private let imageLoader: ImageDataLoader
    private var request = GamesRequest(page: 1, page_size: 10)

    public init(gamesLoader: GamesLoader, imageLoader: ImageDataLoader) {
        self.gamesLoader = gamesLoader
        self.imageLoader = imageLoader
    }

    // First Load
    var onLoadingStateChange: Observer<Bool>?
    var onErrorStateChange: Observer<String?>?
    var onGamesLoad: Observer<[GameCellController]>?
    
    // Paging Load
    var onLoadingNextPageStateChange: Observer<Bool>?
    var onErrorGettingNextPage: Observer<String?>?
    var onNextPageGamesLoad: Observer<[GameCellController]>?

    private var isLoading = false
    
    func loadGames(query: String? = nil) {
        request = GamesRequest(page: 1, page_size: 10, search: query)
        
        onLoadingStateChange?(true)
        isLoading = true
        gamesLoader.load(request: request) { [weak self] result in
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
    
    func loadNextPage() {
        guard !isLoading else { return }
        request.page += 1
        onLoadingNextPageStateChange?(true)
        isLoading = true
        gamesLoader.load(request: request) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingNextPageStateChange?(false)
            self.isLoading = false
            switch result {
            case let .success(games):
                self.onNextPageGamesLoad?(self.map(games: games))
            case .failure:
                self.onErrorGettingNextPage?("Error Fetching next page")
            }
        }
    }
    
    private func map(games: [GameItem]) -> [GameCellController] {
        var controller: [GameCellController] = []
        
        for game in games {
            let gameCellViewModel = GameCellViewModel(model: game, imageLoader: self.imageLoader)
            controller.append(GameCellController(viewModel: gameCellViewModel))
        }
        
        return controller
    }
}

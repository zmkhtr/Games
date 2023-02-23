//
//  DetailViewModel.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games
import UIKit

final class DetailViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let gameLoader: GameDetailLoader
    private let imageLoader: ImageDataLoader
    private let gameCache: GameDetailCache
    private let id: Int
    
    public init(id: Int,
                gameLoader: GameDetailLoader,
                imageLoader: ImageDataLoader,
                gameCache: GameDetailCache
    ) {
        self.id = id
        self.gameLoader = gameLoader
        self.imageLoader = imageLoader
        self.gameCache = gameCache
    }
    
    private var model: GameDetailItem!
    
    var onLoadingStateChange: Observer<Bool>?
    var onErrorStateChange: Observer<String?>?
    var onGameLoad: Observer<GameDetailViewModel>?
    
    var onImageLoad: Observer<UIImage?>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    var onFavoriteChange: Observer<Bool>?
    
    func getDetail() {
        
        onLoadingStateChange?(true)
        onErrorStateChange?(nil)
        
        gameLoader.get(for: id) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStateChange?(false)

            switch result {
            case let .success(game):
                self.model = game
                self.onGameLoad?(
                    GameDetailViewModel(
                        title: game.title,
                        releaseDate: game.releaseDate,
                        rating: game.rating,
                        description: game.description,
                        played: game.played,
                        developers: game.developers,
                        isFavorite: game.isFavorite)
                )
                self.loadImageData(url: game.image)
            case .failure:
                self.onErrorStateChange?("Error Fetching Data")
            }
        }
    }
    
    
    func loadImageData(url: URL?) {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        
        self.onImageLoad?(nil)
        
        guard let imageURL = url else {
            self.onImageLoadingStateChange?(false)
            self.onImageLoad?(UIImage(named: "image_not_found")!)
            return
        }
        
        _ = imageLoader.loadImageData(from: imageURL) { [weak self] result in
            guard let self = self else { return }
            self.onImageLoadingStateChange?(false)
            
            switch result {
            case let .success(data):
                if let image = UIImage(data: data) {
                    self.onImageLoad?(image)
                } else {
                    self.onShouldRetryImageLoadStateChange?(true)
                }
                
            case .failure:
                self.onShouldRetryImageLoadStateChange?(true)
            }
        }
    }
    
    func addRemoveFavorite() {
        model.isFavorite = !model.isFavorite
        gameCache.save(model) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.onFavoriteChange?(self.model.isFavorite)
            case .failure:
                self.onFavoriteChange?(!self.model.isFavorite)
            }
        }
    }
}

struct GameDetailViewModel {
    public let title: String
    public let releaseDate: String
    public let rating: String
    public let description: String
    public let played: String
    public let developers: String
    public let isFavorite: Bool
    
    init(title: String, releaseDate: String, rating: Double, description: String, played: Int, developers: String, isFavorite: Bool) {
        self.title = title
        self.releaseDate = "Release date \(releaseDate)"
        self.rating = "\(rating)"
        self.description = description
        self.played = "\(played)"
        self.developers = developers
        self.isFavorite = isFavorite
    }
}

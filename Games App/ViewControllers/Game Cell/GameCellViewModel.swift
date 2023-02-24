//
//  GameCellViewModel.swift
//  GameUI
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games
import UIKit

class GameCellViewModel {
    typealias Observer<T> = (T) -> Void
    
    private var task: ImageDataLoaderTask?
    let model: GameItem
    private let imageLoader: ImageDataLoader
    
    init(model: GameItem, imageLoader: ImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    var title: String {
        return model.title
    }
    
    var relaseDate: String {
        return "Release date \(model.releaseDate)"
    }
    
    var rating: String {
        return "\(model.rating)"
    }
    
    var onImageLoad: Observer<UIImage?>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        
        self.onImageLoad?(nil)
        
        guard let imageURL = model.image else {
            self.onImageLoadingStateChange?(false)
            self.onImageLoad?(UIImage(named: "image_not_found")!)
            return
        }
        
        task = imageLoader.loadImageData(from: imageURL) { [weak self] result in
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
    
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}

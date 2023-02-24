//
//  GameCellController.swift
//  GameUI
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import UIKit
import Games

class GameCellController {
    private let viewModel: GameCellViewModel
    private var cell: GameCell?
    
    init(viewModel: GameCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView, for index: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: index) as? GameCell
        preload()
        bindViewModel()
        return cell!
    }
    
    func bindViewModel() {
        cell?.labelTitle.text = viewModel.title
        cell?.labelReleaseDate.text = viewModel.relaseDate
        cell?.labelRating.text = viewModel.rating
        cell?.viewImageContainer.isShimmering = true

        viewModel.onImageLoad = { [weak self] image in
            guard let self = self else { return }

            if let size = self.cell?.imageGame.frame.size,
               let image = image,
               let thumb = image.preparingThumbnail(of: size) {
                self.cell?.imageGame.image = thumb
            } else {
                self.cell?.imageGame.image = image
            }
        }
        
        viewModel.onShouldRetryImageLoadStateChange = { [weak self] isShouldRetry in
            guard let self = self else { return }
            if isShouldRetry {
                self.cell?.buttonRetryImage.isHidden = false
                self.cell?.buttonRetryImage.isUserInteractionEnabled = true
            } else {
                self.cell?.buttonRetryImage.isHidden = true
                self.cell?.buttonRetryImage.isUserInteractionEnabled = false
            }
            
        }
        
        viewModel.onImageLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            self.cell?.viewImageContainer.isShimmering = isLoading
        }
        
        cell?.onRetry = { [weak self] in
            guard let self = self else { return }
            self.preload()
        }
        
        cell?.onReuse = { [weak self] in
            guard let self = self else { return }
            self.releaseCellForReuse()
        }
    }
    
    func getItem() -> GameItem {
        return viewModel.model
    }
    
    func preload() {
        viewModel.loadImageData()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        viewModel.cancelImageDataLoad()
    }
    
    private func releaseCellForReuse() {
        cell?.imageGame.image = nil
        cell = nil
    }
}

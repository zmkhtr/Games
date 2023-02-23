//
//  DetailViewController.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelPlayed: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDeveloper: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    
    @IBOutlet weak var buttonRetry: UIButton!
    
    private let viewModel: DetailViewModel
    
    public init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        
        
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, You should't initialize the ViewController through Storyboards")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindViewModelImage()
        bindViewModelFavorite()
    }
    
    private func favoriteButton(isFavorite: Bool) {
        
        let heart = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(addFavorite))
        let heartFill = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .done, target: self, action: #selector(addFavorite))
        
        if isFavorite {
            navigationItem.rightBarButtonItem = heartFill
        } else {
            navigationItem.rightBarButtonItem = heart
        }
    }
    
    @objc private func addFavorite() {
        viewModel.addRemoveFavorite()
    }
    
    private func bindViewModel() {
        viewModel.getDetail()
        
        viewModel.onGameLoad = { [weak self] game in
            guard let self = self else { return }
            self.labelDescription.text = game.description
            self.labelPlayed.text = game.played
            self.labelRating.text = game.rating
            self.labelReleaseDate.text = game.releaseDate
            self.labelTitle.text = game.title
            self.labelDeveloper.text = game.developers
            self.favoriteButton(isFavorite: game.isFavorite)
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.scrollView.refreshControl?.beginRefreshing()
            } else {
                self.scrollView.refreshControl?.endRefreshing()
            }
        }
        
        viewModel.onErrorStateChange = { [weak self] errorMessage in
            guard let self = self else { return }
            if let errorMessage {
                self.presentDialog(message: errorMessage)
            }
        }
    }
    
    private func bindViewModelImage() {
        viewModel.onImageLoad = { [weak self] image in
            guard let self = self else { return }
            self.imageDetail.image = image
        }
        
        viewModel.onImageLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            self.imageContainer.isShimmering = isLoading
        }
        
        viewModel.onShouldRetryImageLoadStateChange = { [weak self] isShouldRetry in
            guard let self = self else { return }
            if isShouldRetry {
                self.buttonRetry.isHidden = false
                self.buttonRetry.isUserInteractionEnabled = true
            } else {
                self.buttonRetry.isHidden = true
                self.buttonRetry.isUserInteractionEnabled = false
            }
            
        }
    }
    
    private func bindViewModelFavorite() {
        viewModel.onFavoriteChange = { [weak self] isFavorite in
            guard let self = self else { return }
            self.favoriteButton(isFavorite: isFavorite)
        }
    }


    private func presentDialog(message: String) {
        let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            switch action.style {
                case .default:
                self.viewModel.getDetail()
                
                default:
                    break
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


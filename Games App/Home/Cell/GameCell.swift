//
//  GameCell.swift
//  GameUI
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var buttonRetryImage: UIButton!
    @IBOutlet weak var viewImageContainer: UIView!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var imageGame: UIImageView!
    
    var onRetry: (() -> Void)?
    var onReuse: (() -> Void)?
    
    @IBAction func retryAction(_ sender: UIButton) {
        onRetry?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        onReuse?()
    }
}

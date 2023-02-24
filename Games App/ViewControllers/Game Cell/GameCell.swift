//
//  GameCell.swift
//  GameUI
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit

public class GameCell: UITableViewCell {

    @IBOutlet private(set) public weak var buttonRetryImage: UIButton!
    @IBOutlet private(set) public weak var viewImageContainer: UIView!
    @IBOutlet private(set) public weak var labelRating: UILabel!
    @IBOutlet private(set) public weak var labelTitle: UILabel!
    @IBOutlet private(set) public weak var labelReleaseDate: UILabel!
    @IBOutlet private(set) public weak var imageGame: UIImageView!
    
    var onRetry: (() -> Void)?
    var onReuse: (() -> Void)?
    
    @IBAction private func retryAction() {
        onRetry?()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        onReuse?()
    }
}

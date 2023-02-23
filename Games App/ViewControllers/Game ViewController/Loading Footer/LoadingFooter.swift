//
//  LoadingFooter.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit

class LoadingFooter: UIView {

    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
 
    static func instanceFromNib() -> LoadingFooter {
        return UINib(nibName: "LoadingFooter", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadingFooter
    }
}

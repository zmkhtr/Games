//
//  TabbarViewController.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit

struct TabbarItem {
    let viewController: UIViewController
    let title: String
    let image: UIImage
}

class TabbarViewController: UITabBarController {

    private let vcItems: [TabbarItem]
    
    public init(vcItems: [TabbarItem]) {
        self.vcItems = vcItems
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, You should't initialize the ViewController through Storyboards")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupVCs()
    }
    
    func setupVCs() {
        let VCs = vcItems.map { item in
            createNavController(for: item.viewController, title: item.title, image: item.image)
        }
        viewControllers = VCs
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            rootViewController.navigationItem.title = title
            return navController
        }
}

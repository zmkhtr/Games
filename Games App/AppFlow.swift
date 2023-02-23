//
//  AppFlow.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games
import CoreData
import UIKit

final class AppFlow {
    lazy var store: ImageDataStore = {
        try! CoreDataImageDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("image-store.sqlite"))
    }()
    
    lazy var httpClient: HTTPClient = {
        let session = URLSession(configuration: .default)
        let httpClient = URLSessionHTTPClient(session: session)
        return AuthenticatedHTTPClientDecorator(decoratee: httpClient)
        
    }()
    
    private let tabbarController: UITabBarController
    private var homeNavigationController: UINavigationController?
    private var favoriteNavigationController: UINavigationController?
    
    init(tabbarController: UITabBarController) {
        self.tabbarController = tabbarController
    }
    
    func start() {
        tabbarController.setViewControllers([
            createHomeVCWithNavigationController(),
            createFavoriteVCWithNavigationController()
        ], animated: true)
    }
    
    private func createHomeVCWithNavigationController() -> UIViewController {
        let homeVC = HomeUIFactory.create(httpClient: httpClient, imageStore: store)
        homeNavigationController = UINavigationController(rootViewController: homeVC)
        homeNavigationController?.tabBarItem.title = "Home"
        homeNavigationController?.tabBarItem.image = UIImage(systemName: "house")
        homeVC.navigationItem.title = "Games For You"
        return homeNavigationController!
    }
    
    private func createFavoriteVCWithNavigationController() -> UIViewController {
        let homeVC = HomeUIFactory.create(httpClient: httpClient, imageStore: store)
        favoriteNavigationController = UINavigationController(rootViewController: homeVC)
        favoriteNavigationController?.tabBarItem.title = "Favorite"
        favoriteNavigationController?.tabBarItem.image = UIImage(systemName: "heart")
        homeVC.navigationItem.title = "Favorite Games"
        return favoriteNavigationController!
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

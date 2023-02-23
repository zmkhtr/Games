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
    
    lazy var imageStore: ImageDataStore = {
        try! CoreDataImageDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("image-store.sqlite"))
    }()
    
    lazy var gameStore: CoreDataGameDetailStore = {
        try! CoreDataGameDetailStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("game-store.sqlite"))
    }()
    
    lazy var httpClient: HTTPClient = {
        let session = URLSession(configuration: .default)
        let httpClient = URLSessionHTTPClient(session: session)
        return AuthenticatedHTTPClientDecorator(decoratee: httpClient)
        
    }()
    
    lazy var imageLoader: ImageDataLoader = {
        let imageCache = LocalImageDataLoader(store: imageStore)
        let remoteImageLoader = RemoteImageDataLoader(client: httpClient)
        let imageCacheDecorator = ImageLoaderWithCacheDecorator(
            decoratee: remoteImageLoader,
            cache: imageCache)
        let imageFallback = ImageLoaderWithFallBackComposite(
            primary: imageCache,
            fallback: imageCacheDecorator)
        return imageFallback
    }()
    
    lazy var baseURL: URL = {
       return URL(string: "https://api.rawg.io/api/games")!
    }()
    
    private let tabbarController: UITabBarController
    private var homeNavigationController: UINavigationController!
    private var favoriteNavigationController: UINavigationController!
    
    private var favoriteVC: FavoriteListViewController!
    
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
        let homeVC = HomeUIFactory.create(httpClient: httpClient, imageLoader: imageLoader, baseURL: baseURL, onGameSelected: presentDetailHome)
        homeNavigationController = UINavigationController(rootViewController: homeVC)
        homeNavigationController.tabBarItem.title = "Home"
        homeNavigationController.tabBarItem.image = UIImage(systemName: "house")
        homeVC.navigationItem.title = "Games For You"
        return homeNavigationController
    }
    
    private func createFavoriteVCWithNavigationController() -> UIViewController {
        favoriteVC = FavoriteUIFactory.create(imageLoader: imageLoader, gameStore: gameStore, onGameSelected: presentDetailFavorite)
        favoriteNavigationController = UINavigationController(rootViewController: favoriteVC)
        favoriteNavigationController.tabBarItem.title = "Favorite"
        favoriteNavigationController.tabBarItem.image = UIImage(systemName: "heart")
        favoriteVC.navigationItem.title = "Favorite Games"
        return favoriteNavigationController
    }
    
    private func presentDetailHome(id: Int) {
        let detailVC = DetailUIFactory.create(id: id, gameStore: gameStore, imageLoader: imageLoader, httpClient: httpClient, baseURL: baseURL)
        detailVC.onFavoriteChange = { [weak self] in
            self?.favoriteVC.refresh()
        }
        homeNavigationController.pushViewController(detailVC, animated: true)
    }
    
    private func presentDetailFavorite(id: Int) {
        let detailVC = DetailUIFactory.create(id: id, gameStore: gameStore, imageLoader: imageLoader, httpClient: httpClient, baseURL: baseURL)
        detailVC.onFavoriteChange = { [weak self] in
            self?.favoriteVC.refresh()
        }
        favoriteNavigationController.pushViewController(detailVC, animated: true)
    }
}

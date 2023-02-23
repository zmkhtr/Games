//
//  SceneDelegate.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        let homeVCitem = TabbarItem(viewController: HomeUIFactory.create(), title: "Games For you", image: UIImage(systemName: "house")!)
        let homeVCitem1 = TabbarItem(viewController: HomeUIFactory.create(), title: "Home", image: UIImage(systemName: "house")!)
        let tabBar = TabbarViewController(vcItems: [homeVCitem, homeVCitem1])
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }

}


//
//  SceneDelegate.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var tabbarController = UITabBarController()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        let flow = AppFlow(tabbarController: tabbarController)
        flow.start()
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
    }

}


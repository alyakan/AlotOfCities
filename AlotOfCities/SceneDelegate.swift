//
//  SceneDelegate.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 30/01/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: MainCoordinator?

    /**
     I like creating view controllers programatically as opposed to using Storyboards as this gives me more controler
     over their dependencies.
     */
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navController = UINavigationController()
        coordinator = MainCoordinator(rootController: navController, appDependency: AppDependency())
        coordinator?.start()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}


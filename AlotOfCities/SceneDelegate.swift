//
//  SceneDelegate.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 30/01/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let viewModel = CitiesViewModel(dataTransportLayer: JsonDataTransportLayer())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navController = UINavigationController(rootViewController: CitiesTableViewController(viewModel: viewModel))
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}


//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Victoria Belinschi on 06.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let viewController = ViewController(nibName: String(describing: ViewController.self), bundle: nil)
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }
}


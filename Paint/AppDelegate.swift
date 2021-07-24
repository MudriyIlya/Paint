//
//  AppDelegate.swift
//  Paint
//
//  Created by Илья Мудрый on 24.07.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: TestViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}


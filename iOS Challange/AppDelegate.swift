//
//  AppDelegate.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/15/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        window?.rootViewController = loginViewController
        return true
    }
}


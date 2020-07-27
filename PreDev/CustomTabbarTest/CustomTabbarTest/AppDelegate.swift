//
//  AppDelegate.swift
//  CustomTabbarTest
//
//  Created by user on 2020/07/27.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)

        self.window?.rootViewController = TabbarViewController()
        self.window?.makeKeyAndVisible()

        return true
    }

}


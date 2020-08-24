//
//  AppDelegate.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/07/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)

        self.window?.rootViewController = HomeViewController()
        self.window?.makeKeyAndVisible()

        if FileManager.default.ubiquityIdentityToken != nil {
            LoadCoreDataManager.shared.fetchLoad()
        } else {
            LoadCoreDataManager.shared.insertDefaultGroupForUnavailableiCloudUser()
        }

//        if #available(iOS 13.0, *) {
//            VocaCoreDataManager.shared
//        } else {
//            // Fallback on earlier versions
//        }

        return true
    }

}

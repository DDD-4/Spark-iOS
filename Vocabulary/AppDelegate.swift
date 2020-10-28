//
//  AppDelegate.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/07/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)


        let splashViewController = UIStoryboard(name: "Splash", bundle: nil).instantiateViewController(withIdentifier: "SplashViewController") as UIViewController

        let viewController = splashViewController

        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()

        FirebaseApp.configure()

        return true
    }

}

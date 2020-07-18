//
//  AppDelegate.swift
//  CardMatching
//
//  Created by LEE HAEUN on 2020/07/18.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.window = UIWindow(frame: UIScreen.main.bounds)

        let imageWords = [
            ImageWord(image: "poop", word: "poop"),
            ImageWord(image: "puppy", word: "puppy"),
            ImageWord(image: "robot", word: "robot"),
            ImageWord(image: "subway", word: "subway"),
        ]
        self.window?.rootViewController = ViewController(imageWords: imageWords)
        self.window?.makeKeyAndVisible()
        return true
    }
}


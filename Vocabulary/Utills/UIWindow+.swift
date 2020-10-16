//
//  UIWindow+.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/10/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

extension UIWindow {
  func topMostViewController() -> UIViewController? {
    guard let rootViewController = self.rootViewController else {
      return nil
    }
    return topViewController(for: rootViewController)
  }

  func topViewController(for rootViewController: UIViewController?) -> UIViewController? {
    guard let rootViewController = rootViewController else {
      return nil
    }
    guard let presentedViewController = rootViewController.presentedViewController else {
      return rootViewController
    }
    switch presentedViewController {
    case is UINavigationController:
      let navigationController = presentedViewController as! UINavigationController
      return topViewController(for: navigationController.viewControllers.last)
    case is UITabBarController:
      let tabBarController = presentedViewController as! UITabBarController
      return topViewController(for: tabBarController.selectedViewController)
    default:
      return topViewController(for: presentedViewController)
    }
  }
}

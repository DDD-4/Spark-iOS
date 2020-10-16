//
//  UIAlerController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/10/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

extension UIAlertController {
    func presentShowAlert(
        title: String? = nil,
        message: String? = nil,
        leftButtonTitle: String? = nil,
        rightButtonTitle: String? = nil,
        completionHandler: @escaping ((Int) -> Void)
    ) {
        if let rootViewController = UIApplication.shared.windows.first?.topMostViewController() {
            let controller = showAlert(
                title: title,
                message: message,
                leftButtonTitle: leftButtonTitle,
                rightButtonTitle: rightButtonTitle,
                completionHandler: completionHandler
            )
            rootViewController.present(controller, animated: true, completion: nil)
        }
    }

    func showAlert(
        title: String? = nil,
        message: String? = nil,
        leftButtonTitle: String? = nil,
        rightButtonTitle: String? = nil,
        completionHandler: @escaping ((Int) -> Void)
    ) -> UIAlertController {
        let controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        if let leftTitle = leftButtonTitle {
            let leftAction = UIAlertAction(
                title: leftTitle,
                style: .default,
                handler: { _ in
                    completionHandler(0)
                }
            )
            controller.addAction(leftAction)
        }

        if let rightTitle = rightButtonTitle {
            let rightAction = UIAlertAction(
                title: rightTitle,
                style: .default,
                handler: { _ in
                    completionHandler(1)
                }
            )
            controller.addAction(rightAction)
        }

        return controller
    }
}

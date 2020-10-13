//
//  SplashViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/10/14.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import RxSwift

class SplashViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let identifier = UserDefaults.standard.getUserLoginIdentifier() {
            requestLogin(credential: identifier)
        } else {
            let loginViewController = LoginViewController()

            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
              return
            }
            window.rootViewController = loginViewController
        }
    }

    func requestLogin(credential: String) {
        UserController.shared.login(credential: credential)
            .subscribe { [weak self] (response) in
                if response.element?.statusCode == 200 {
                    self?.transitionToHome()
                }
            }.disposed(by: disposeBag)
    }

    func transitionToHome() {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
          return
        }

        let viewController = UINavigationController(rootViewController: HomeViewController())
        viewController.navigationBar.isHidden = true

        window.rootViewController = viewController
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(
            with: window,
            duration: duration,
            options: options,
            animations: {},
            completion: nil)
    }
}

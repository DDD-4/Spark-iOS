//
//  TabbarViewController.swift
//  CustomTabbarTest
//
//  Created by user on 2020/07/27.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(centerButtonDidTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let tabOne = UINavigationController(rootViewController: ViewController(tabLabel: "1"))
        let tabOneBarItem = UITabBarItem(title: "1", image: nil, selectedImage: nil)
        tabOne.tabBarItem = tabOneBarItem

        let tabTwo = UINavigationController(rootViewController: ViewController(tabLabel: "2"))
        let tabTwoBarItem2 = UITabBarItem(title: "2", image: nil, selectedImage: nil)
        tabTwo.tabBarItem = tabTwoBarItem2

        let tab3 = UINavigationController(rootViewController: ViewController(tabLabel: "3"))
        let tabBarItem3 = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        tabBarItem3.isEnabled = false
        tab3.tabBarItem = tabBarItem3

        let tab4 = UINavigationController(rootViewController: ViewController(tabLabel: "4"))
        let tabBarItem4 = UITabBarItem(title: "4", image: nil, selectedImage: nil)
        tab4.tabBarItem = tabBarItem4

        let tab5 = UINavigationController(rootViewController: ViewController(tabLabel: "5"))
        let tabBarItem5 = UITabBarItem(title: "5", image: nil, selectedImage: nil)
        tab5.tabBarItem = tabBarItem5

        self.viewControllers = [tabOne, tabTwo, tab3, tab4, tab5]


        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 20)
        ])
    }

    @objc func centerButtonDidTap(_ sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor == .black ? .red : .black
    }
}

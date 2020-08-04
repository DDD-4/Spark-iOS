//
//  TabbarViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
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

        let tabOne = UINavigationController(rootViewController: MyVocaViewController())
        let tabOneBarItem = UITabBarItem(title: "1", image: nil, selectedImage: nil)
        tabOne.tabBarItem = tabOneBarItem

        let tabTwo = UINavigationController(rootViewController: MyVocaViewController())
        let tabTwoBarItem2 = UITabBarItem(title: "2", image: nil, selectedImage: nil)
        tabTwo.tabBarItem = tabTwoBarItem2

        let tab3 = UINavigationController(rootViewController: MyVocaViewController())
        let tabBarItem3 = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        tabBarItem3.isEnabled = false
        tab3.tabBarItem = tabBarItem3

        let tab4 = UINavigationController(rootViewController: VocaForAllViewController(groups: []))
        let tabBarItem4 = UITabBarItem(title: "4", image: nil, selectedImage: nil)
        tab4.tabBarItem = tabBarItem4

        let tab5 = UINavigationController(rootViewController: MyVocaViewController())
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
        present(AddWordViewController(), animated: true, completion: nil)
    }
    
    func hiddenTabBar(_ bool: Bool) {
        tabBar.isHidden = bool
        button.isHidden = bool
    }
}

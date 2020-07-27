//
//  ViewController.swift
//  CustomTabbarTest
//
//  Created by user on 2020/07/27.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(tabLabel: String) {
        super.init(nibName: nil, bundle: nil)

        label.text = tabLabel
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


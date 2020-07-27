//
//  MyVocaViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import Voca

class MyVocaViewController: UIViewController {

    lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        return stack
    }()

    lazy var fetchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("fetch CloudKit", for: .normal)
        button.backgroundColor = .red
        return button
    }()

    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("add CloudKit", for: .normal)
        button.backgroundColor = .orange
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }

    func configureLayout() {
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(fetchButton)
        buttonStackView.addArrangedSubview(addButton)

        buttonStackView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.equalTo(100)
        }
    }

    @objc func fetchDidTap(_ sender: UIButton) {

    }

    @objc func addDidTap(_ sender: UIButton) {

    }
}

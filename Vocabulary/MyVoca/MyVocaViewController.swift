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

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.textColor = .black
        return textView
    }()

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
        button.addTarget(self, action: #selector(fetchDidTap(_:)), for: .touchUpInside)
        return button
    }()

    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("add CloudKit", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(addDidTap(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }

    func configureLayout() {
        view.addSubview(textView)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(fetchButton)
        buttonStackView.addArrangedSubview(addButton)

        textView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(buttonStackView.snp.top)
        }

        buttonStackView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.equalTo(100)
        }
    }

    @objc func fetchDidTap(_ sender: UIButton) {
        VocaManager.shared.fetch(
            identifier: nil, completion: { [weak self] data in
                let count = data?.count
                DispatchQueue.main.async {
                    self?.textView.text = "\(count)"
                }
        })
    }

    @objc func addDidTap(_ sender: UIButton) {
        VocaManager.shared.insert(
            group: Group(
                title: "test",
                visibilityType: .public,
                identifier: UUID())
        )
    }
}

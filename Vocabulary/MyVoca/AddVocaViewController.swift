//
//  AddVocaViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import PoingDesignSystem

class AddVocaViewController: UIViewController {
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "폴더 추가"
        return label
    }()

    lazy var groupNameTextField: VDSTextField = {
        let textField = VDSTextField(theme: .gray)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "폴더명을 입력해주세요."
        return textField
    }()

    lazy var confirmButton: AccentButton = {
        let button = AccentButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }

    func configureLayout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(groupNameTextField)
        containerView.addSubview(confirmButton)


        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerY.centerX.equalTo(view)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.top).offset(32)
            make.leading.trailing.equalTo(containerView)
        }

        groupNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(34)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
            make.height.equalTo(47)
        }

        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(groupNameTextField.snp.bottom).offset(20)
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView).offset(-18)
        }
    }
}

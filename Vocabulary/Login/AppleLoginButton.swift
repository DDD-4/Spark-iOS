//
//  AppleLoginButton.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/12.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

class AppleLoginButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.isUserInteractionEnabled = false

        addSubview(stackView)

        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.leading.greaterThanOrEqualTo(self)
            make.trailing.lessThanOrEqualTo(self)
            make.centerX.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [appleImage, loginLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 0
        return stack
    }()

    lazy var appleImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "iconApple")
        return view
    }()

    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apple로 로그인"
        label.textColor = .midnight
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

}


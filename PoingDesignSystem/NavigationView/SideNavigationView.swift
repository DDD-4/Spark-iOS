//
//  SideNavigationView.swift
//  VocaDesignSystem
//
//  Created by LEE HAEUN on 2020/08/04.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class SideNavigationView: UIView {
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    public lazy var leftSideButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    public lazy var rightSideButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()

    public init(leftImage: UIImage?, centerTitle: String?, rightImage: UIImage?) {
        super.init(frame: .zero)
        configureLayout()
        if let image = leftImage {
            leftSideButton.setImage(image, for: .normal)
        }

        if let image = rightImage {
            rightSideButton.setImage(image, for: .normal)
        }

        titleLabel.text = centerTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(leftSideButton)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(rightSideButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: LeftTitleNavigationView.Constant.height),

            leftSideButton.widthAnchor.constraint(equalToConstant: 24),
            rightSideButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}

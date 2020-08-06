//
//  PopNavigationView.swift
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

    lazy var popButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()

    public init(leftImage: UIImage?, centerTitle: String?, rightImage: UIImage?) {
        super.init(frame: .zero)

        if let image = leftImage {
            popButton.setImage(image, for: .normal)
        }

        if let image = rightImage {
            addButton.setImage(image, for: .normal)
        }

        titleLabel.text = centerTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(popButton)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(addButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: LeftTitleNavigationView.Constant.height),

            popButton.widthAnchor.constraint(equalToConstant: 24),
            addButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}

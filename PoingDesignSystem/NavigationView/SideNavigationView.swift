//
//  SideNavigationView.swift
//  VocaDesignSystem
//
//  Created by LEE HAEUN on 2020/08/04.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class SideNavigationView: UIView {
    lazy var navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public lazy var leftSideButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return button
    }()

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .midnight
        return label
    }()

    public lazy var rightSideButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        button.setTitleColor(.midnight, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
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
        addSubview(navigationView)
        navigationView.addSubview(leftSideButton)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(rightSideButton)

        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            navigationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: LeftTitleNavigationView.Constant.height),

            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leftSideButton.trailingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightSideButton.leadingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),


            leftSideButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
            leftSideButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),

            rightSideButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
            rightSideButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor)

        ])
    }
}

//
//  LeftTitleNavigationView.swift
//  VocaDesignSystem
//
//  Created by LEE HAEUN on 2020/08/04.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class LeftTitleNavigationView: UIView {
    enum Constant {
        static let height: CGFloat = 44
    }

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public init(title: String, rightTitle: String?) {
        super.init(frame: .zero)
        configureLayout()
        titleLabel.text = title
        rightButton.setTitle(rightTitle, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightButton)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: Constant.height),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor),

            rightButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

//
//  GuideView.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/10/25.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem

class GuideView: UIView {
    enum Constant {
        static let radius: CGFloat = 16
    }

    lazy var titleAreaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.midnight.withAlphaComponent(0.8)
        view.layer.cornerRadius = Constant.radius
        view.clipsToBounds = true
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    init(image: UIImage, title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        imageView.image = image

        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(image: UIImage, title: String) {
        titleLabel.text = title
        imageView.image = image
    }

    func configureLayout() {
        isUserInteractionEnabled = false
        
        addSubview(titleAreaView)
        titleAreaView.addSubview(titleLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 144),
            imageView.heightAnchor.constraint(equalToConstant: 144),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleAreaView.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor),
            titleAreaView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleAreaView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleAreaView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            titleLabel.topAnchor.constraint(equalTo: titleAreaView.topAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: titleAreaView.bottomAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleAreaView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: titleAreaView.trailingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

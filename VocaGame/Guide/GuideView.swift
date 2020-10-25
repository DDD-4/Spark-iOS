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
        static let radius: CGFloat = 32
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "카드를 터치해서 단어의 이미지 확인하기"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "luggageFreepik")
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
        backgroundColor = UIColor.midnight.withAlphaComponent(0.8)
        layer.cornerRadius = Constant.radius
        clipsToBounds = true

        addSubview(titleLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.heightAnchor.constraint(equalToConstant: 48),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
}

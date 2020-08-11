//
//  GameCell.swift
//  Vocabulary
//
//  Created by user on 2020/08/01.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class GameCell: UICollectionViewCell {
    enum Constant {
        static let height: CGFloat = 120

        enum Thumb {
            static let height: CGFloat = 48
            static let radius: CGFloat = 12
        }
        enum Title {
            static let font = UIFont.systemFont(ofSize: 21, weight: .bold)
            static let color = UIColor(red: 17.0 / 255.0, green: 28.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
        }
    }

    static let reuseIdentifier = String(describing: GameCell.self)

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadow(color: UIColor(red: 138.0 / 255.0, green: 149.0 / 255.0, blue: 158.0 / 255.0, alpha: 0.2), alpha: 1, x: 0, y: 10, blur: 60, spread: 0)
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constant.Title.font
        label.textColor = Constant.Title.color
        return label
    }()

    lazy var thumbImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .blue
        view.layer.cornerRadius = Constant.Thumb.radius
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    func configureLayout() {
        backgroundColor = .white

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(thumbImageView)

        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(Constant.height)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(thumbImageView.snp.trailing).offset(24)
            make.trailing.equalTo(containerView)
        }

        thumbImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.height.width.equalTo(Constant.Thumb.height)
            make.leading.equalTo(containerView).offset(24)
        }
    }
}

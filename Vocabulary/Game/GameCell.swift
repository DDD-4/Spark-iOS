//
//  GameCell.swift
//  Vocabulary
//
//  Created by user on 2020/08/01.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import PoingDesignSystem
import VocaGame

class GameCell: UICollectionViewCell {
    enum Constant {
        enum Thumb {
            static let height: CGFloat = 32
        }
        enum Title {
            static let font = UIFont.systemFont(ofSize: 20, weight: .bold)
            static let color = UIColor.midnight
        }
    }

    static let reuseIdentifier = String(describing: GameCell.self)

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadow(
            color: .cement20,
            alpha: 1,
            x: 0,
            y: 4,
            blur: 20,
            spread: 0
        )
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
        return view
    }()

    lazy var arrowImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "icSettingArrow")
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

    func configure(_ style: GameStyle) {
        titleLabel.text = style.type.rawValue
        thumbImageView.image = style.image
    }

    func configureLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(thumbImageView)
        containerView.addSubview(arrowImageView)

        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
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

        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(8)
            make.height.equalTo(14)
        }
    }
}

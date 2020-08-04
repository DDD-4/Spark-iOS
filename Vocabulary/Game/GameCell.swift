//
//  GameCell.swift
//  Vocabulary
//
//  Created by user on 2020/08/01.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class GameCell: UITableViewCell {
    enum Constant {
        static let height: CGFloat = 120
    }

    static let reuseIdentifier = String(describing: GameCell.self)

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        selectionStyle = .none
        backgroundColor = .gray

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(arrowButton)

        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(Constant.height)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.centerX.equalTo(containerView)
        }

        arrowButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.trailing.equalTo(containerView).offset(-20)
            make.height.width.equalTo(24)
        }
    }
}

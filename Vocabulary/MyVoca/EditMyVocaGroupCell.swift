//
//  EditMyVocaGroupCell.swift
//  Vocabulary
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

class EditMyVocaGroupCell: UITableViewCell {
    static let reuseIdentifier = String(describing: EditMyVocaGroupCell.self)

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    lazy var groupEditStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupNameLabel, editButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()

    lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var moreStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteButton, publicButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 15)
        return button
    }()

    lazy var publicButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 15)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(group: Group) {
        groupNameLabel.text = group.title

        switch group.visibilityType {
        case .group, .public:
            publicButton.setTitle("공개 중", for: .normal)
        case .private:
            publicButton.setTitle("공개하기", for: .normal)
        }
    }

    func configureLayout() {
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(groupEditStackView)
        containerView.addSubview(moreStackView)

        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }

        groupEditStackView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.top).offset(24)
            make.leading.equalTo(containerView.snp.leading).offset(24)
            make.trailing.lessThanOrEqualTo(containerView.snp.trailing).offset(-24)
            make.height.equalTo(24)
        }

        moreStackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(containerView.snp.bottom).offset(-24)
            make.leading.greaterThanOrEqualTo(containerView.snp.leading).offset(24)
            make.trailing.equalTo(containerView.snp.trailing).offset(-24)
            make.top.equalTo(groupEditStackView.snp.bottom).offset(40)
        }

        editButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
        }
    }
}

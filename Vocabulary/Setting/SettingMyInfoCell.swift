//
//  SettingMyInfoCell.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/27.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

protocol SettingMyInfoCellDelegate: class {
    func settingMyInfoCell(_ cell: SettingMyInfoCell, didTapEdit button: UIButton)
}

class SettingMyInfoCell: UITableViewCell {
    static let reuseIdentifier = String(describing: SettingMyInfoCell.self)
    enum Constant {
        static let radius: CGFloat = 20
        enum Profile {
            static let length: CGFloat = 56
            static let image = UIImage(named: "yellowFace")
        }
        enum Name {
            static let font = UIFont.systemFont(ofSize: 20, weight: .bold)
            static let color = UIColor.midnight
        }
        enum Edit {
            static let width: CGFloat = 80
            static let height: CGFloat = 32
            static let font = UIFont.systemFont(ofSize: 12, weight: .bold)
            static let color = UIColor.slateGrey
            static let backgroundColor = UIColor(white: 244/255, alpha: 1)
            static let radius: CGFloat = 16
            static let text = "프로필 수정"
        }
    }

    weak var delegate: SettingMyInfoCellDelegate?

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadow(
            color: .greyblue20,
            alpha: 1,
            x: 0,
            y: 4,
            blur: 20,
            spread: 0
        )
        view.layer.cornerRadius = Constant.radius
        view.backgroundColor = .white
        return view
    }()

    lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = Constant.Profile.image
        view.layer.cornerRadius = Constant.Profile.length * 0.5
        view.clipsToBounds = true   
        return view
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constant.Name.font
        label.textColor = Constant.Name.color
        return label
    }()

    lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constant.Edit.radius
        button.setTitle(Constant.Edit.text, for: .normal)
        button.setTitleColor(Constant.Edit.color, for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = Constant.Edit.backgroundColor
        button.titleLabel?.font = Constant.Edit.font
        button.addTarget(self, action: #selector(editDidTap(_:)), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(profile: String?, name: String) {
        nameLabel.text = name
        if let profileStringUrl = profile, let profileUrl = URL(string: profileStringUrl) {
            profileImageView.sd_setImage(with: profileUrl) { [weak self] (image, error, _, _) in
                guard error == nil else {
                    self?.profileImageView.image = Constant.Profile.image
                    self?.profileImageView.layer.cornerRadius = Constant.Profile.length * 0.5
                    return
                }
            }
        }
    }

    func configureLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        clipsToBounds = false

        contentView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(editButton)

        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(104)
            make.bottom.equalTo(contentView).offset(-24)
        }

        profileImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(Constant.Profile.length)
            make.leading.equalTo(containerView).offset(20)
            make.centerY.equalTo(containerView)
        }

        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(editButton.snp.leading)
        }

        editButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(containerView).offset(-20)
            make.centerY.equalTo(containerView)
            make.width.equalTo(Constant.Edit.width)
            make.height.equalTo(Constant.Edit.height)
        }
    }

    @objc func editDidTap(_ sender: UIButton) {
        delegate?.settingMyInfoCell(self, didTapEdit: sender)
    }
}

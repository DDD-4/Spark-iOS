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

protocol EditMyVocaGroupCellDelegate: class {
    func editMyVocaGroupCell(
        _ cell: UICollectionViewCell,
        didTapChangeVisibility button: UIButton,
        group: Folder
    )
    func editMyVocaGroupCell(
        _ cell: UICollectionViewCell,
        didTapDeleteSelect button: UIButton,
        group: Folder
    )
    func editMyVocaGroupCell(
        _ cell: UICollectionViewCell,
        didTapEdit button: UIButton,
        folder: Folder
    )
}

class EditMyVocaGroupCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: EditMyVocaGroupCell.self)

    enum Constant {
        enum Public {
            static let backgrounColor = UIColor.brightSkyBlue
            static let fontColor = UIColor.white
        }
        enum Private {
            static let backgrounColor = UIColor(white: 244.0 / 255.0, alpha: 1.0)
            static let fontColor = UIColor(white: 174.0 / 255.0, alpha: 1.0)
        }

        enum RightButton {
            enum Move {
                static let image = UIImage(named: "icnMove")
                static let width: CGFloat = 16
                static let height: CGFloat = 12
            }
            enum Check {
                static let inactiveImage = UIImage(named: "icnInactiveCheck")
                static let activeImage = UIImage(named: "icnActiveCheck")
                static let length: CGFloat = 24
            }
        }
    }
    var group: Folder?
    weak var delegate: EditMyVocaGroupCellDelegate?

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
        stackView.alignment = .center
        return stackView
    }()

    lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icEdit"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editFolderDidTap), for: .touchUpInside)
        return button
    }()

    lazy var publicButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.layer.cornerRadius = 24 * 0.5
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.addTarget(self, action: #selector(changeVisibilityTypeDidTap(_:)), for: .touchUpInside)
        return button
    }()

    lazy var rightButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var selectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constant.RightButton.Check.activeImage, for: .selected)
        button.setImage(Constant.RightButton.Check.inactiveImage, for: .normal)
        button.addTarget(self, action: #selector(selectDeleteDidTap(_:)), for: .touchUpInside)
        return button
    }()

    lazy var moveImageView: UIImageView = {
        let imageView = UIImageView(image: Constant.RightButton.Move.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        group: Folder,
        state: EditMyFolderViewController.State,
        isDeleteSelected: Bool
    ) {
        self.group = group
        groupNameLabel.text = group.name
        setVisibilityColor(group: group)

        switch state {
        case .delete:
            selectButton.isHidden = false
            moveImageView.isHidden = true
            editButton.isHidden = true
        case .normal:
            selectButton.isHidden = true
            moveImageView.isHidden = false
            editButton.isHidden = false
        }

        selectButton.isSelected = isDeleteSelected
    }

    func configureLayout() {
        backgroundColor = .whiteTwo
        contentView.addSubview(containerView)
        containerView.addSubview(groupEditStackView)
        containerView.addSubview(publicButton)

        contentView.addSubview(rightButtonView)
        rightButtonView.addSubview(selectButton)
        rightButtonView.addSubview(moveImageView)

        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-56)
        }

        groupEditStackView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.top).offset(28)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.lessThanOrEqualTo(containerView.snp.trailing).offset(-20)
        }

        publicButton.snp.makeConstraints { (make) in
            make.top.equalTo(groupEditStackView.snp.bottom).offset(9)
            make.bottom.equalTo(containerView.snp.bottom).offset(-28)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.lessThanOrEqualTo(containerView)
            make.height.equalTo(24)
        }

        rightButtonView.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView.snp.trailing)
            make.trailing.equalTo(contentView)
            make.top.bottom.equalTo(contentView)
        }

        editButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
        }

        selectButton.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView.snp.trailing)
            make.trailing.equalTo(contentView)
            make.center.equalTo(rightButtonView)
        }

        moveImageView.snp.makeConstraints { (make) in
            make.width.equalTo(Constant.RightButton.Move.width)
            make.height.equalTo(Constant.RightButton.Move.height)
            make.center.equalTo(rightButtonView)
        }
    }

    func setVisibilityColor(group: Folder) {
        if let folder = group as? FolderCoreData {
            switch folder.visibilityType {
            case .group, .public:
                setPublicConfigure()
            case .private:
                setPrivateConfigure()
            case .default:
                break
            }
        } else {
            if group.shareable {
                setPublicConfigure()
            } else {
                setPrivateConfigure()
            }
        }
    }

    func setPublicConfigure() {
        publicButton.setTitle("공개 중", for: .normal)
        publicButton.backgroundColor = Constant.Public.backgrounColor
        publicButton.setTitleColor(Constant.Public.fontColor, for: .normal)
    }

    func setPrivateConfigure() {
        publicButton.setTitle("공개하기", for: .normal)
        publicButton.backgroundColor = Constant.Private.backgrounColor
        publicButton.setTitleColor(Constant.Private.fontColor, for: .normal)
    }

    @objc func changeVisibilityTypeDidTap(_ sender: UIButton) {
        guard let group = group else {
            return
        }
        delegate?.editMyVocaGroupCell(self, didTapChangeVisibility: sender, group: group)
    }

    @objc func selectDeleteDidTap(_ sender: UIButton) {
        guard let group = group else {
            return
        }
        selectButton.isSelected = !selectButton.isSelected
        delegate?.editMyVocaGroupCell(self, didTapDeleteSelect: sender, group: group)
    }

    @objc func editFolderDidTap(_ sender: UIButton) {
        guard let group = group else {
            return
        }

        delegate?.editMyVocaGroupCell(self, didTapEdit: sender, folder: group)
    }
}

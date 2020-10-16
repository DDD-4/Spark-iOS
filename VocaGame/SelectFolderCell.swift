//
//  SelectFolderCell.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/09/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import PoingVocaSubsystem
import PoingDesignSystem

class SelectFolderCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: SelectFolderCell.self)

    enum Constant {
        static let sideMargin: CGFloat = 16
        enum Image {
            static let height: CGFloat = 48
        }
        enum TextContents {
            static let leftMargin: CGFloat = 20
            static let bottomMargin: CGFloat = 18
        }
        static let imageRadius: CGFloat = 24
    }

    var folder: Folder?

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadow(
            color: UIColor(red: 138.0 / 255.0, green: 149.0 / 255.0, blue: 158.0 / 255.0, alpha: 1),
            alpha: 0.2,
            x: 0,
            y: 10,
            blur: 60,
            spread: 0
        )
        view.layer.cornerRadius = 20
        view.clipsToBounds = false
        view.backgroundColor = .white
        return view
    }()
    lazy var folderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.imageRadius
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    lazy var folderTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .midnight
        return label
    }()

    lazy var radioButton: RadioButton = {
        let radioButton = RadioButton()
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        clipsToBounds = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        folderImageView.sd_cancelCurrentImageLoad()
    }

    func configure(folder: Folder) {
        self.folder = folder
        folderTitleLabel.text = folder.name
        folderImageView.image = UIImage(named: "emptyFace")

        if let folderCoreData = folder as? FolderCoreData {
            guard folderCoreData.words.isEmpty == false,
                  let imageData = folderCoreData.words.first?.image else {
                return
            }
            folderImageView.image = UIImage(data: imageData)
        } else {
            folderImageView.sd_setImage(with: URL(string: folder.photoUrl))
        }
    }

    func configureLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(folderImageView)
        containerView.addSubview(folderTitleLabel)
        containerView.addSubview(radioButton)

        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.top.equalTo(self)
        }

        folderImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView).offset(20)
            make.top.equalTo(containerView).offset(20)
            make.width.height.equalTo(Constant.Image.height)
        }

        folderTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView).offset(20)
            make.bottom.equalTo(containerView).offset(-20)
            make.trailing.equalTo(containerView).offset(-50)
        }

        radioButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(24)
        }
    }
}

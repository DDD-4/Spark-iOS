//
//  MyVocaWordCell.swift
//  Vocabulary
//
//  Created by user on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import PoingVocaSubsystem

class MyVocaWordCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: MyVocaWordCell.self)

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        return imageView
    }()

    lazy var EnglishLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "test"
        return label
    }()

    lazy var KoreanLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "test"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemPink
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(word: Word) {
        EnglishLabel.text = word.english
        KoreanLabel.text = word.korean
    }

    func configureLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(EnglishLabel)
        contentView.addSubview(KoreanLabel)

        imageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(contentView.snp.width)
        }

        EnglishLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
        }

        KoreanLabel.snp.makeConstraints { (make) in
            make.top.equalTo(EnglishLabel.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
}

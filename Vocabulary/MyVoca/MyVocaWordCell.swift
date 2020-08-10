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

protocol MyVocaWordCellDelegate: class {
    func MyVocaWord(didTapEdit button: UIButton, selectedWord word: Word)
}

class MyVocaWordCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: MyVocaWordCell.self)

    enum Constant {
        static let imageRadius: CGFloat = 12
    }

    weak var delegate: MyVocaWordCellDelegate?

    var word: Word?

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.imageRadius
        return imageView
    }()

    lazy var EnglishLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var KoreanLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var editButton: UIButton = {
      let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.addTarget(self, action: #selector(editButtonDidTap(_:)), for: .touchUpInside)
      return button
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
        self.word = word
        EnglishLabel.text = word.english
        KoreanLabel.text = word.korean
    }

    func configureLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(EnglishLabel)
        contentView.addSubview(KoreanLabel)
        contentView.addSubview(editButton)

        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
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

        editButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.trailing.equalTo(contentView).offset(-16)
            make.width.height.equalTo(40)
        }
    }

    @objc
    func editButtonDidTap(_ sender: UIButton) {
        guard let word = word else {
            return
        }
        delegate?.MyVocaWord(didTapEdit: sender, selectedWord: word)
    }
}

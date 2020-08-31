//
//  WordDetailCell.swift
//  Vocabulary
//
//  Created by apple on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import SDWebImage

class WordDetailCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: WordDetailCell.self)
    enum Constant {
        static let sideMargin: CGFloat = 11
        enum Image {
            static let height: CGFloat = 102
        }
        enum TextContents {
            static let contentTopMargin: CGFloat = 11
            static let height: CGFloat = 214
            static let radius: CGFloat = 20
        }
    }
    lazy var vocaImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.Image.height * 0.5
        view.image = UIImage(named: "icPicture")
        view.backgroundColor = .lightGray
        return view
    }()
    lazy var textContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadow(
            color: UIColor(red: 138.0 / 255.0, green: 149.0 / 255.0, blue: 158.0 / 255.0, alpha: 1),
            alpha: 0.2,
            x: 0,
            y: 4,
            blur: 20,
            spread: 0
        )
        view.layer.cornerRadius = Constant.TextContents.radius
        view.clipsToBounds = false
        view.backgroundColor = .white
        return view
    }()
    lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [englishLabel, koreanLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 6
        return stack
    }()
    lazy var koreanLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .slateGrey
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    lazy var englishLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.BalsamiqSansBold(size: 24)
        label.textColor = UIColor.darkIndigo
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        //label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = false
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        vocaImageView.sd_cancelCurrentImageLoad()
    }

    func configure(wordDownload: WordDownload) {
        englishLabel.text = wordDownload.english
        koreanLabel.text = wordDownload.korean
        if let urlImage = URL(string: wordDownload.imageURL) {
            vocaImageView.sd_setImage(with: urlImage)
        }
    }

    func configure(word: Word) {
        englishLabel.text = word.english
        koreanLabel.text = word.korean
    }

    func configureLayout() {
        contentView.addSubview(textContentView)
        contentView.addSubview(vocaImageView)
        textContentView.addSubview(textStackView)

        vocaImageView.snp.makeConstraints { (make) in
            make.top.equalTo(textContentView.safeAreaLayoutGuide.snp.top).offset(24)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.width.equalTo(Constant.Image.height)
        }
        textContentView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(Constant.TextContents.contentTopMargin)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
        }
        textStackView.snp.makeConstraints { (make) in
            make.top.equalTo(textContentView).offset(138)
            make.leading.trailing.equalTo(textContentView)
            make.bottom.equalTo(textContentView).offset(-24)
        }
    }
}

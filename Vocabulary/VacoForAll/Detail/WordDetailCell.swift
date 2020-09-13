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

    lazy var containerView: UIView = {
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

    lazy var koreanLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .slateGrey
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    lazy var englishLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.QuicksandBold(size: 24)
        label.textColor = UIColor.midnight
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.baselineAdjustment = .alignCenters
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

    override func layoutSubviews() {
        super.layoutSubviews()
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
        guard let image = word.image else { return }
        vocaImageView.image = UIImage(data: image)
    }

    func configureLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(vocaImageView)
        containerView.addSubview(englishLabel)
        containerView.addSubview(koreanLabel)

        containerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(contentView)
        }

        vocaImageView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView).offset(24)
            make.centerX.equalTo(containerView.snp.centerX)
            make.height.width.equalTo(Constant.Image.height)
        }

        englishLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vocaImageView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(containerView)
        }

        koreanLabel.snp.makeConstraints { (make) in
            make.top.equalTo(englishLabel.snp.bottom).offset(6)
            make.leading.trailing.equalTo(containerView)
            make.bottom.lessThanOrEqualTo(containerView)
        }
    }
}

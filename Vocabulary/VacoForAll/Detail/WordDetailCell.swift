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
    
    lazy var vocaImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.image = UIImage(named: "icPicture")
        return view
    }()
    lazy var KoreanLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    lazy var EnglishLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        vocaImageView.sd_cancelCurrentImageLoad()
    }

    func configure(wordDownload: WordDownload) {
        EnglishLabel.text = wordDownload.english
        KoreanLabel.text = wordDownload.korean
        if let urlImage = URL(string: wordDownload.imageURL) {
            vocaImageView.sd_setImage(with: urlImage)
        }
    }

    func configure(word: Word) {
        EnglishLabel.text = word.english
        KoreanLabel.text = word.korean
    }

    func configureLayout() {
        contentView.addSubview(vocaImageView)
        contentView.addSubview(EnglishLabel)
        contentView.addSubview(KoreanLabel)

        vocaImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(contentView.snp.width)
        }

        EnglishLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vocaImageView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
        }

        KoreanLabel.snp.makeConstraints { (make) in
            make.top.equalTo(EnglishLabel.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
    }
}

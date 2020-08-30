//
//  VocaForAllCell.swift
//  Vocabulary
//
//  Created by apple on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

class VocaForAllCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: VocaForAllCell.self)

    enum Constant {
        enum VocaImage {
            static let length: CGFloat = 166
        }
        static let imageRadius: CGFloat = 12
    }

    lazy var vocaImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.VocaImage.length * 0.5
        view.backgroundColor = .lightGray
        return view
    }()
    lazy var numberView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        view.layer.borderWidth = 1.7
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = .orange
        return view
    }()
    lazy var numberLable: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layoutMargins = UIEdgeInsets(
            top: 4,
            left: 4,
            bottom: 4,
            right: 4)
        view.textColor = .white
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 26)
        label.numberOfLines = 0
        label.textColor = .darkIndigo
        return label
    }()
    lazy var authorContentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .slateGrey
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    lazy var authorImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icPicture")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24 * 0.5
        return imageView
    }()
    lazy var baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 32
        view.layer.shadow(
            color: .greyblue20,
            alpha: 1,
            x: 0,
            y: 10,
            blur: 60,
            spread: 0)
        view.backgroundColor = .white
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(dummy: VocaForAll) {
        //titleLabel.text = dummy.title
        titleLabel.text = "내가 좋아하는 달달한 간식"
        authorLabel.text = "홍길동"
        if let urlImage = URL(string: dummy.words[0].imageURL) {
            vocaImageView.sd_setImage(with: urlImage)
        }
        authorImageView.image = UIImage(named: "icPicture")
        numberLable.text = "\(dummy.words.count)"
    }

    func configure(group: Group) {
        titleLabel.text = group.title
        authorLabel.text = "\(group.identifier)"
        if let data = group.words[0].image {
            vocaImageView.image = UIImage(data: data)
        }
        authorImageView.image = UIImage(named: "icPicture")
        numberLable.text = "\(group.words.count)"
    }

    func configureLayout() {
        contentView.backgroundColor = .white
        contentView.addSubview(baseView)
        baseView.addSubview(vocaImageView)
        baseView.addSubview(numberView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(authorContentView)
        baseView.addSubview(numberView)
        numberView.addSubview(numberLable)
        authorContentView.addSubview(authorImageView)
        authorContentView.addSubview(authorLabel)

        baseView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(baseView.snp.leading).offset(32)
            make.top.equalTo(baseView.snp.top).offset(32)
            make.trailing.equalTo(baseView).offset(-(Constant.VocaImage.length * 0.5) - 32)
        }

        authorContentView.snp.makeConstraints { (make) in
            make.leading.equalTo(baseView.snp.leading).offset(32)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        authorImageView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(authorContentView)
            make.width.height.equalTo(24)
        }
        authorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(authorImageView.snp.trailing).offset(8)
            make.centerY.equalTo(authorImageView)
        }

        vocaImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(Constant.VocaImage.length)
            make.bottom.equalTo(baseView.snp.bottom).offset(-32)
            make.trailing.equalTo(baseView.snp.trailing).offset(-32)
        }

        numberView.snp.makeConstraints { (make) in
            make.centerY.equalTo(vocaImageView).offset(-20)
            make.trailing.equalTo(vocaImageView.snp.trailing)
        }

        numberLable.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(numberView)
        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

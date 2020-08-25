//
//  MyVocaEmptyCell.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/10.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class MyVocaEmptyCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: MyVocaEmptyCell.self)

    let Constant = MyVocaWordCell.Constant.self

    enum Constant_ {
        static let imageHeight: CGFloat = 231
        static let mainText = "앗 단어카드가 없어요..!"
        static let descriptionText = "아래 버튼을 눌러서\n나만의 단어장을 만들어 보아요!"
        static let image = UIImage(named: "emptyFace")
    }

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant_.imageHeight * 0.5
        imageView.image = Constant_.image
        return imageView
    }()

    lazy var textContentView: UIView = {
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
        stack.spacing = 14
        return stack
    }()


    lazy var englishLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = UIColor(red: 17.0 / 255.0, green: 28.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = Constant_.mainText
        return label
    }()

    lazy var koreanLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 127.0 / 255.0, green: 129.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = Constant_.descriptionText
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        contentView.addSubview(textContentView)
        contentView.addSubview(imageView)
        textContentView.addSubview(textStackView)

        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.width.equalTo(Constant_.imageHeight)
        }
        textContentView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(Constant.TextContents.contentTopMargin)
            make.leading.equalTo(Constant.sideMargin)
            make.trailing.equalTo(-Constant.sideMargin)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
        }
        textStackView.snp.makeConstraints { (make) in
            make.top.equalTo(textContentView).offset(206)
            make.leading.trailing.equalTo(textContentView)
            make.bottom.equalTo(textContentView).offset(-48)
        }

    }

}

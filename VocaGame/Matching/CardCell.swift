//
//  CardCell.swift
//  CardMatching
//
//  Created by LEE HAEUN on 2020/07/18.
//

import UIKit
import PoingDesignSystem

class CardCell: UICollectionViewCell {
    enum Constant {
        static let radius: CGFloat = 16
        static let borderWidth: CGFloat = 6
        static let font = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let textColor = UIColor.darkIndigo
    }
    static let reuseIdentifier = String(describing: CardCell.self)

    var cardMatching: CardMatching?

    lazy var frontView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constant.radius
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()

    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()

    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Constant.font
        label.textColor = Constant.textColor
        label.font = UIFont.QuicksandBold(size: 24)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.minimumScaleFactor = 0.1
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        deselected()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(card: CardMatching) {
        cardMatching = card

        switch card.contentType {
        case .image(let image):
            imageView.image = image
        case .imageURL(let imageUrl):
            imageView.sd_imageTransition = .fade
            imageView.sd_setImage(with: imageUrl, completed: nil)
        case .text(let text):
            wordLabel.text = text
        }
    }

    func selected() {
        switch cardMatching?.contentType {
        case .image, .imageURL:
            frontView.layer.borderWidth = Constant.borderWidth
            frontView.layer.borderColor = cardMatching?.color.cgColor
        case .text:
            frontView.backgroundColor = cardMatching?.color
            wordLabel.textColor = .white
        default:
            return
        }
    }

    func deselected() {
        wordLabel.textColor = Constant.textColor
        frontView.backgroundColor = .white
        frontView.layer.borderColor = UIColor.clear.cgColor
    }

    func configureLayout() {

        contentView.addSubview(frontView)
        frontView.addSubview(imageView)
        frontView.addSubview(wordLabel)

        NSLayoutConstraint.activate([
            frontView.topAnchor.constraint(equalTo: contentView.topAnchor),
            frontView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            frontView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            frontView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: frontView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: frontView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: frontView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: frontView.bottomAnchor),

            wordLabel.topAnchor.constraint(equalTo: frontView.topAnchor),
            wordLabel.leadingAnchor.constraint(equalTo: frontView.leadingAnchor),
            wordLabel.trailingAnchor.constraint(equalTo: frontView.trailingAnchor),
            wordLabel.bottomAnchor.constraint(equalTo: frontView.bottomAnchor),

        ])
    }

}

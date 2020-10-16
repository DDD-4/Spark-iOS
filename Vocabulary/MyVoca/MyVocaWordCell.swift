//
//  MyVocaWordCell.swift
//  Vocabulary
//
//  Created by user on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import PoingVocaSubsystem
import PoingDesignSystem
import SDWebImage

protocol MyVocaWordCellDelegate: class {
    func myVocaWord(didTapEdit button: UIButton, selectedWord word: Word)
    func myVocaWord(_ cell: UICollectionViewCell, didTapMic button: UIButton, selectedWord word: Word)
}

class MyVocaWordCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MyVocaWordCell.self)
    
    enum Constant {
        static let sideMargin: CGFloat = 16
        enum Image {
            static let height: CGFloat = 263
        }
        enum TextContents {
            static let contentTopMargin: CGFloat = 60
            static let height: CGFloat = 343
            static let radius: CGFloat = 32
        }
        enum Edit {
            static let width: CGFloat = 18
        }
        static let micImage: UIImage? = UIImage(named: "icVoice")
        static let touchedMicImage: UIImage? = UIImage(named: "icVoiceSpeaking")
        static let micImageHeight: CGFloat = 48
        static let imageRadius: CGFloat = 12
        
    }
    
    weak var delegate: MyVocaWordCellDelegate?
    
    var word: Word?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.Image.height * 0.5
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    lazy var micButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constant.micImage, for: .normal)
        button.setImage(Constant.touchedMicImage, for: .selected)
        button.addTarget(self, action: #selector(micButtonDidTap(_:)), for: .touchUpInside)
        return button
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
        stack.spacing = 3
        return stack
    }()
    
    
    lazy var englishLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.QuicksandBold(size: 46)
        label.textColor = UIColor.darkIndigo
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var koreanLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .slateGrey
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icnEdit"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(editButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()

    var pulse: PulseAnimation?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = false
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(word: Word) {
        self.word = word
        englishLabel.text = word.english
        koreanLabel.text = word.korean
        if let wordCoreData = word as? WordCoreData {
            guard let image = wordCoreData.image else {
                return
            }
            imageView.image = UIImage(data: image)
        } else {
            guard let imageUrlString = word.photoUrl,
                  let imageUrl = URL(string: imageUrlString) else {
                return
            }
            imageView.sd_imageTransition = .fade
            imageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        stopAnimation()
        imageView.sd_cancelCurrentImageLoad()
    }
    
    func configureLayout() {
        clipsToBounds = false
        backgroundColor = .clear
        
        contentView.addSubview(editButton)
        contentView.addSubview(textContentView)
        contentView.addSubview(imageView)
        contentView.addSubview(micButton)
        textContentView.addSubview(textStackView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.width.equalTo(Constant.Image.height)
        }
        micButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.width.height.equalTo(Constant.micImageHeight)
            make.bottom.equalTo(imageView.snp.bottom).offset(Constant.micImageHeight * 0.5)
        }
        editButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(textContentView.snp.top).offset(-18)
            make.trailing.equalTo(contentView).offset(-Constant.sideMargin)
            make.width.height.equalTo(Constant.Edit.width)
        }
        textContentView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(Constant.TextContents.contentTopMargin)
            make.leading.equalTo(Constant.sideMargin)
            make.trailing.equalTo(-Constant.sideMargin)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
        }
        textStackView.snp.makeConstraints { (make) in
            make.top.equalTo(textContentView).offset(222)
            make.leading.trailing.equalTo(textContentView)
            make.bottom.equalTo(textContentView).offset(-28)
        }
        
    }
    
    @objc func editButtonDidTap(_ sender: UIButton) {
        guard let word = word else {
            return
        }
        delegate?.myVocaWord(didTapEdit: sender, selectedWord: word)
    }
    
    @objc func micButtonDidTap(_ sender: UIButton) {
        guard let word = word else {
            return
        }
        delegate?.myVocaWord(self, didTapMic: sender, selectedWord: word)
    }

    public func startAnimation() {
        micButton.isSelected = true

        let pulse = PulseAnimation(
            radius: Constant.micImageHeight * 0.8,
            position: micButton.center
        )
        pulse.animationDuration = 0.8
        pulse.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.8690668736, blue: 0.5490196347, alpha: 1)
        contentView.layer.insertSublayer(pulse, below: micButton.layer)

        self.pulse = pulse
    }

    public func stopAnimation() {
        pulse?.stop()
        micButton.isSelected = false
        pulse = nil
    }
}



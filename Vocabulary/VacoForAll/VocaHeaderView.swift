//
//  VocaHeaderView.swift
//  Vocabulary
//
//  Created by apple on 2020/08/29.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class VocaHeaderView: UIView {
    enum Constant {
        enum Profile {
            static let height: CGFloat = 18
            static let imageHeight: CGFloat = 24
        }
    }
    
    // MARK: - Properties
    lazy var vocaTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 26)
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .midnight
        return label
    }()
    lazy var profileContentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .slateGrey
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        return label
    }()
    lazy var profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.Profile.imageHeight * 0.5
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        vocaTitle: String,
        profileName: String,
        profileImage: UIImage?
    ) {
        vocaTitleLabel.text = vocaTitle
        profileLabel.text = profileName
        profileImageView.image = UIImage(named: "icPicture")
    }

    func configureLayout() {
        addSubview(vocaTitleLabel)
        addSubview(profileContentView)
        
        profileContentView.addSubview(profileImageView)
        profileContentView.addSubview(profileLabel)
        
        vocaTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(24)
            make.leading.trailing.equalTo(self)
        }
        
        profileContentView.snp.makeConstraints { (make) in
            make.top.equalTo(vocaTitleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(self)
        }
        
        profileImageView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(profileContentView)
            make.width.height.equalTo(Constant.Profile.imageHeight)
        }

        profileLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(profileContentView)
            make.centerY.equalTo(profileImageView)
        }
    }
    
}

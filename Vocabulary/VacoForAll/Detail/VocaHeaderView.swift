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
        enum Title {
            static let width: CGFloat = 261
        }
        enum Profile {
            static let height: CGFloat = 18
            static let imageHeight: CGFloat = 24
        }
    }
    
    // MARK: - Properties
    lazy var vocaTitle: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 26)
        label.textAlignment = .center
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
    
    init(vocaTitle: String, profileName: String, profileImage: UIImage?) {
        super.init(frame: .zero)
        self.vocaTitle.text = vocaTitle
        self.profileLabel.text = profileName
        self.profileImageView.image = UIImage(named: "icPicture")
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        self.addSubview(vocaTitle)
        self.addSubview(profileContentView)
        
        profileContentView.addSubview(profileImageView)
        profileContentView.addSubview(profileLabel)
        
        vocaTitle.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
        }
        
        profileContentView.snp.makeConstraints { (make) in
            make.top.equalTo(vocaTitle.snp.bottom).offset(8)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
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

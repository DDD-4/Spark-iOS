//
//  UserinfoHeader.swift
//  Vocabulary
//
//  Created by apple on 2020/08/04.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class UserinfoHeader: UIView {
    
    // MARK: - Properties
    lazy var contentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "icPicture")
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, emailLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 3
        return stack
    }()
    
    lazy var usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "Tony Stark"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "test@test.com"
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(contentView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        
        contentView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(self)
        }
        profileImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.height.width.equalTo(40)
        }
        stackView.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.centerY.equalTo(profileImageView)
        }
    }
}

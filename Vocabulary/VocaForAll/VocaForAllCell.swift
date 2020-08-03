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
import Voca

class VocaForAllCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: VocaForAllCell.self)
    
    lazy var vocaImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    lazy var numberView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .gray
        return view
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, authorLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 3
        return stack
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .gray
        return label
    }()
    lazy var baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(group: Group) {
        titleLabel.text = group.title
        authorLabel.text = "\(group.identifier)"
        vocaImageView.image = UIImage(named: "icPicture")
        numberView.text = "\(group.words.count)"
    }
    
    func configureLayout() {
        contentView.addSubview(baseView)
        baseView.addSubview(stackView)
        baseView.addSubview(vocaImageView)
        baseView.addSubview(numberView)
        
        baseView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        vocaImageView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(baseView)
            make.height.width.equalTo(88)
        }
        
        numberView.snp.makeConstraints { (make) in
            make.trailing.equalTo(baseView).offset(-16)
            make.centerY.equalTo(baseView)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(baseView)
            make.leading.equalTo(vocaImageView.snp.trailing).offset(16)
            make.trailing.equalTo(numberView).offset(-8)
        }
        
    }
    
}

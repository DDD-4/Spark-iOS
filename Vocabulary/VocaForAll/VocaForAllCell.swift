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

class VocaForAllCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: VocaForAllCell.self)
    
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
        static let micImageHeight: CGFloat = 48
        static let imageRadius: CGFloat = 12

    }
    
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

    func configure(dummy: VocaForAll) {
        titleLabel.text = dummy.title
    }

    func configure(group: Group) {
        titleLabel.text = group.title
        authorLabel.text = "\(group.identifier)"
        vocaImageView.image = UIImage(named: "icPicture")
        numberView.text = "\(group.words.count)"
    }
    
    func configureLayout() {
        
        contentView.addSubview(baseView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(vocaImageView)
        //baseView.addSubview(numberView)
        
        baseView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
        }
        
        vocaImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(baseView).offset(-12)
            make.top.equalTo(baseView).offset(12)
            make.bottom.equalTo(baseView).offset(-12)
            make.height.width.equalTo(96)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(baseView).offset(24)
            make.centerY.equalTo(baseView)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

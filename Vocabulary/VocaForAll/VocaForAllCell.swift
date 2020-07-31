//
//  VocaForAllCell.swift
//  Vocabulary
//
//  Created by apple on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

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
        view.text = "4"
        view.backgroundColor = .gray
        return view
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
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        baseView.addSubview(titleLabel)
        baseView.addSubview(authorLabel)
        baseView.addSubview(vocaImageView)
        baseView.addSubview(numberView)
        
        vocaImageView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(baseView)
            make.height.width.equalTo(88)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(baseView.snp.top).offset(17)
            make.leading.equalTo(vocaImageView.snp.trailing).offset(16)
        }
        
        authorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(vocaImageView.snp.trailing).offset(16)
        }
        
        numberView.snp.makeConstraints { (make) in
            make.trailing.equalTo(baseView).offset(-16)
            make.centerX.equalTo(baseView)
        }
    }
    
}

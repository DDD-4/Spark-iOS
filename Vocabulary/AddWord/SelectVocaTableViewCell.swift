//
//  SelectVocaTableViewCell.swift
//  Vocabulary
//
//  Created by apple on 2020/08/10.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import PoingVocaSubsystem

class SelectVocaTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: SelectVocaTableViewCell.self)

    enum Constant {
        static let imageRadius: CGFloat = 12
    }
    
    var group: FolderCoreData?

    lazy var VocaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = Constant.imageRadius
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(group: FolderCoreData) {
        self.group = group
        VocaLabel.text = group.name
    }

    func configureLayout() {
        contentView.addSubview(VocaLabel)
        
        VocaLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(9)
            make.leading.trailing.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(14)
        }
    }
}

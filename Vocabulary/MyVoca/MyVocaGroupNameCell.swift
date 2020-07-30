//
//  MyVocaGroupNameCell.swift
//  Vocabulary
//
//  Created by user on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class MyVocaGroupNameCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MyVocaGroupNameCell.self)

    override var isSelected: Bool {
        didSet {
            isSelected ? selected() : deSelected()
        }
    }

    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        layer.cornerRadius = 18
        contentView.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }

    func configure(groupName: String) {
        name.text = groupName
    }

    func selected() {
        backgroundColor = .black
        name.textColor = .white
    }

    func deSelected() {
        backgroundColor = .white
        name.textColor = .black
    }
}

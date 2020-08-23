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
    enum Constant {
        enum Active {
            static let font = UIFont.systemFont(ofSize: 14, weight: .bold)
            static let backgroundColor = UIColor(red: 74.0 / 255.0, green: 191.0 / 255.0, blue: 1.0, alpha: 1.0)
            static let fontColor = UIColor.white
        }
        enum Inactive {
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let backgroundColor = UIColor(white: 244.0 / 255.0, alpha: 1.0)
            static let fontColor = UIColor(red: 127.0 / 255.0, green: 129.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0)
        }

        static let height: CGFloat = 36
    }

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
            make.center.equalTo(contentView)
            make.height.equalTo(Constant.height)
        }
    }

    func configure(groupName: String) {
        name.text = groupName
    }

    func selected() {
        backgroundColor = Constant.Active.backgroundColor
        name.textColor = Constant.Active.fontColor
        name.font = Constant.Active.font
    }

    func deSelected() {
        backgroundColor = Constant.Inactive.backgroundColor
        name.textColor = Constant.Inactive.fontColor
        name.font = Constant.Inactive.font
    }
}

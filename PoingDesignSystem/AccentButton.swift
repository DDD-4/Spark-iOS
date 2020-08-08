//
//  AccentButton.swift
//  VocaDesignSystem
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class AccentButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        contentEdgeInsets = UIEdgeInsets(top: 15, left: 76, bottom: 15, right: 76)
        backgroundColor = .black
        titleLabel?.textColor = .white
        layer.cornerRadius = 30
    }
}

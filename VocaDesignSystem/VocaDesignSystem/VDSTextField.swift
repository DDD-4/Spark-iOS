//
//  VDSTextField.swift
//  VocaDesignSystem
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class VDSTextField: UITextField {

    public enum Theme {
        case gray
        case white
    }

    let themeType: Theme

    public init(theme: Theme) {
        themeType = theme
        super.init(frame: .zero)

        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        rightViewMode = .always

        switch themeType {
        case .gray:
            backgroundColor = .gray
            textColor = .white
        case .white:
            backgroundColor = .white
            textColor = .black
        }
    }
    
}

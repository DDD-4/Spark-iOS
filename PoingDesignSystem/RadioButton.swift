//
//  RadioButton.swift
//  PoingDesignSystem
//
//  Created by LEE HAEUN on 2020/09/26.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class RadioButton: UIButton {
    public init() {
        super.init(frame: .zero)

        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        setImage(UIImage(named: "selectorNormal"), for: .normal)
        setImage(UIImage(named: "selectorSelected"), for: .selected)
    }

}

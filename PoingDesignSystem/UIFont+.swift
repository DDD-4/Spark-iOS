//
//  UIFont+.swift
//  VocaDesignSystem
//
//  Created by apple on 2020/07/29.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit.UIFont

public extension UIFont {
    static func BalsamiqSansBold(size: CGFloat) -> UIFont {for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }

        return UIFont(name: "BalsamiqSansBold", size: size)!
    }
}

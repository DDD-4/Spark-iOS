//
//  UIColor+.swift
//  VocaDesignSystem
//
//  Created by LEE HAEUN on 2020/07/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit.UIColor

public extension UIColor {

    class var greyblue20: UIColor {
        return UIColor(red: 138.0 / 255.0, green: 149.0 / 255.0, blue: 158.0 / 255.0, alpha: 0.2)
    }

    class var darkIndigo: UIColor {
        return UIColor(red: 17.0 / 255.0, green: 28.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    }

    class var brightCyan: UIColor {
        return UIColor(red: 74.0 / 255.0, green: 191.0 / 255.0, blue: 1.0, alpha: 1.0)
    }

    class var dandelion50: UIColor {
        return UIColor(red: 1.0, green: 221.0 / 255.0, blue: 14.0 / 255.0, alpha: 0.5)
    }

    class var greyblue50: UIColor {
        return UIColor(red: 138.0 / 255.0, green: 149.0 / 255.0, blue: 158.0 / 255.0, alpha: 0.5)
    }

    class var veryLightPink: UIColor {
        return UIColor(white: 223.0 / 255.0, alpha: 1.0)
    }

    class var dandelion: UIColor {
        return UIColor(red: 1.0, green: 221.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
    }

    class var brightSkyBlue50: UIColor {
        return UIColor(red: 9.0 / 255.0, green: 208.0 / 255.0, blue: 250.0 / 255.0, alpha: 0.5)
    }

    class var brightSkyBlue: UIColor {
        return UIColor(red: 9.0 / 255.0, green: 208.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }

    class var whiteTwo: UIColor {
        return UIColor(white: 247.0 / 255.0, alpha: 1.0)
    }

    class var slateGrey: UIColor {
        return UIColor(red: 90.0 / 255.0, green: 92.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    }

    class var gameBackgroundColor: UIColor {
        return UIColor(red: 1.0, green: 253.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }

    class var cement20: UIColor {
        return UIColor(red: 158.0 / 255.0, green: 155.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.2)
    }

    class var midnight: UIColor {
        return UIColor(red: 4.0 / 255.0, green: 10.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    }

    class var grey244: UIColor {
        return UIColor(white: 244.0 / 255.0, alpha: 1.0)
    }
    class var goldenYellow40: UIColor {
        return UIColor(red: 1.0, green: 218.0 / 255.0, blue: 19.0 / 255.0, alpha: 0.4)
    }

    class var orangered40: UIColor {
        return UIColor(red: 1.0, green: 63.0 / 255.0, blue: 12.0 / 255.0, alpha: 0.4)
    }
    
    class var confettiBlue: UIColor {
        return UIColor(red: 81.0 / 255.0, green: 226.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
}

public extension UIColor {
    func HSBRandomColor() -> UIColor {
        let saturation: CGFloat = 0.49
        let brigtness: CGFloat = 0.86
        let randomHue = CGFloat.random(in: 0.0..<1.0)
        return UIColor(
            hue: randomHue,
            saturation: saturation,
            brightness: brigtness,
            alpha: 1
        )
    }

    @nonobjc class var brownGrey: UIColor {
        return UIColor(white: 174.0 / 255.0, alpha: 1.0)
    }
}

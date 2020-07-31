//
//  UILabel+.swift
//  Vocabulary
//
//  Created by user on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit.UILabel

private let stringMeasureLabel = UILabel()

extension UILabel {
    public static func measureSize(
        with string: String?,
        font: UIFont?,
        width: CGFloat,
        numberOfLines: Int,
        lineBreakMode: NSLineBreakMode
    ) -> CGSize {
        guard let string = string, let font = font else {
            return .zero
        }

        let measureLabel = stringMeasureLabel
        measureLabel.numberOfLines = numberOfLines
        measureLabel.lineBreakMode = lineBreakMode
        measureLabel.text = string
        measureLabel.font = font

        let maxHeight: CGFloat = 20_000
        var measuredSize = measureLabel.sizeThatFits(CGSize(width: width, height: maxHeight))
        measuredSize = CGSize(width: min(ceil(measuredSize.width), width), height: ceil(measuredSize.height))

        return measuredSize
    }
}

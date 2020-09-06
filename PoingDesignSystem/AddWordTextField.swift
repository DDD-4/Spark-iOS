//
//  VDSTextField.swift
//  VocaDesignSystem
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class AddWordTextField: UITextField {
    enum Constant {
        enum TextField {
            static let font = UIFont.systemFont(ofSize: 20, weight: .bold)
            static let color = UIColor.midnight
        }
        enum Line {
            static let color = UIColor.grey244
            static let height: CGFloat = 1
        }
    }

    public override var placeholder: String? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes: [NSAttributedString.Key : Any] = [
                .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 20) as Any,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.veryLightPink,
            ]
            let attrString = NSAttributedString(string: placeholder ?? "", attributes: attributes)

            self.attributedPlaceholder = attrString
        }
    }

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Line.color
        return view
    }()

    var accentLineWidthConstraint: NSLayoutConstraint?
    
    public init() {
        super.init(frame: .zero)

        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRect(x: 0, y: bounds.height + 11, width: bounds.width, height: Constant.Line.height)
    }

    func configureLayout() {
        textAlignment = .center
        font = Constant.TextField.font
        tintColor = Constant.TextField.color
        textColor = Constant.TextField.color

        addSubview(lineView)
    }
    
}

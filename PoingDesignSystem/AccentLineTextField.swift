//
//  AccentLineTextField.swift
//  PoingDesignSystem
//
//  Created by LEE HAEUN on 2020/08/26.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//
// https://zpl.io/aNXOMEv

import UIKit

public class AccentLineTextField: UIView {
    enum Constant {
        static let font = UIFont.systemFont(ofSize: 26, weight: .bold)
        static let placeholderColor = UIColor.veryLightPink
        static let color = UIColor.midnight

        static let spacing: CGFloat = 16

        enum Line {
            static let height: CGFloat = 2
            enum Accent {
                static let color = UIColor.brightSkyBlue
            }

            enum Unaccent {
                static let color = UIColor(white: 244/255, alpha: 1)
            }
        }
    }

    var accentLineWidthConstraint: NSLayoutConstraint?

    public var placeholder: String? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            let attributes: [NSAttributedString.Key : Any] = [
                .font: Constant.font as Any,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.veryLightPink,
            ]
            let attrString = NSAttributedString(string: placeholder ?? "", attributes: attributes)

            textField.attributedPlaceholder = attrString
        }
    }

    public lazy var textField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.clearButtonMode = UITextField.ViewMode.whileEditing
        text.textColor = Constant.color
        text.font = Constant.font
        text.tintColor = Constant.color
        text.delegate = self
        return text
    }()

    lazy var accentLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.Line.Accent.color
        return view
    }()

    lazy var unAccentLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.Line.Unaccent.color
        return view
    }()

    public init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(textField)
        addSubview(unAccentLineView)
        addSubview(accentLineView)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),

            unAccentLineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constant.spacing),
            unAccentLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            unAccentLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            unAccentLineView.heightAnchor.constraint(equalToConstant: Constant.Line.height),
            unAccentLineView.bottomAnchor.constraint(equalTo: bottomAnchor),

            accentLineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constant.spacing),
            accentLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            accentLineView.heightAnchor.constraint(equalToConstant: Constant.Line.height),
        ])


        accentLineWidthConstraint = accentLineView.widthAnchor.constraint(equalToConstant: 0)
        accentLineWidthConstraint?.isActive = true
    }
}

// MARK: - UITextFieldDelegate

extension AccentLineTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.accentLineWidthConstraint?.constant = self.frame.width
            self.layoutIfNeeded()
        }
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.accentLineWidthConstraint?.constant = 0
            self.layoutIfNeeded()
        }
    }
}

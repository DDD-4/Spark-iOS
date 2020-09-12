//
//  LoginViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/12.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem

class LoginViewController: UIViewController {
    enum Constant {
        static let sideMargin: CGFloat = 40
        enum Button {
            static let height: CGFloat = 60
        }

        enum Terms {
            static let text = "가입을 진행할 경우, 서비스 약관 및 개인정보 처리방침에 동의하시게 됩니다."
            static let privacyRange = NSRange(location: 12, length: 6)
            static let termsRange = NSRange(location: 21, length: 9)

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    func configureLayout() {
        view.backgroundColor = .brightSkyBlue
        view.addSubview(logoImageView)
        view.addSubview(appleLoginButton)
        view.addSubview(termsLabel)

        logoImageView.snp.makeConstraints { (make) in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }

        appleLoginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(termsLabel.snp.top).offset(-24)
            make.leading.equalTo(view).offset(Constant.sideMargin)
            make.trailing.equalTo(view).offset(-Constant.sideMargin)
            make.height.equalTo(Constant.Button.height)
        }

        termsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.leading.equalTo(view).offset(Constant.sideMargin)
            make.trailing.equalTo(view).offset(-Constant.sideMargin)
        }
    }
    lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var appleLoginButton: AppleLoginButton = {
        var button = AppleLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constant.Button.height * 0.5
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(appleLoginDidTap), for: .touchUpInside)
        return button
    }()

    lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = 20
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont(name: "AppleSDGothicNeo-Regular", size: 12) as Any,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        ]
        let attrString = NSMutableAttributedString(string: Constant.Terms.text, attributes: attributes)

        attrString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: Constant.Terms.privacyRange)

        attrString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: Constant.Terms.termsRange)

        label.attributedText = attrString
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsTapGesture))
        label.addGestureRecognizer(tapGesture)
        return label
    }()

    @objc func termsTapGesture(_ gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: Constant.Terms.privacyRange) {
            // TODO: Privacy
        } else if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: Constant.Terms.termsRange) {
            // TODO: Terms
        }
    }

    @objc func appleLoginDidTap(_ sender: UIButton) {
        AppleLoginHelper.shared.setDelegate(self)
        AppleLoginHelper.shared.handleAppleIdRequest()
    }
}

extension LoginViewController: LoginDelegate {
    func login(userIdentifier: String) {
        // TODO: store identifier for sign in..
        print(userIdentifier)

        navigationController?.pushViewController(SignInNameViewController(), animated: true)
    }


}

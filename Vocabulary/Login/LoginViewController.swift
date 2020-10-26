//
//  LoginViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/12.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem
import PoingVocaSubsystem
import RxSwift
import RxCocoa
import Moya

class LoginViewController: UIViewController {
    enum Constant {
        static let topImage = UIImage(named: "duck")
        static let bottomImage = UIImage(named: "doughnut")

        static let sideMargin: CGFloat = 40
        enum Button {
            static let height: CGFloat = 60
        }

        enum Terms {
            static let text = "가입을 진행할 경우, 서비스 약관 및 개인정보 처리방침에 동의하시게 됩니다."
            static let privacyRange = NSRange(location: 21, length: 9)
            static let privacyLink = "https://www.notion.so/haeuncs/d1b48a54c9d94a07857764b39b1d53e8"
            static let termsRange = NSRange(location: 12, length: 6)
            static let termsLink = "https://www.notion.so/haeuncs/72dc72dd9c704835ad7d46c64d8dddd6"

        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(logoImageViewTop)
        view.addSubview(logoImageViewBottom)
        view.addSubview(descriptionLabel)
        view.addSubview(appleLoginButton)
        view.addSubview(termsLabel)

        logoImageViewTop.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(hasTopNotch ? 134 : 85)
            make.trailing.equalTo(view).priority(.high)
            make.leading.greaterThanOrEqualToSuperview()
        }

        logoImageViewBottom.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageViewTop.snp.bottom).offset(hasTopNotch ? -52 : -76)
            make.trailing.equalTo(view).offset(-24)
            make.leading.greaterThanOrEqualToSuperview()
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(40)
            make.trailing.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(38)
            make.bottom.equalTo(view).priority(.low)
        }

        appleLoginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(termsLabel.snp.top).offset(-16)
            make.leading.equalTo(view).offset(Constant.sideMargin)
            make.trailing.equalTo(view).offset(-Constant.sideMargin)
            make.height.equalTo(Constant.Button.height)
        }

        termsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(hasTopNotch ? -8 : -24)
            make.leading.equalTo(view).offset(Constant.sideMargin)
            make.trailing.equalTo(view).offset(-Constant.sideMargin)
        }
    }

    lazy var logoImageViewTop: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.image = Constant.topImage
        return view
    }()

    lazy var logoImageViewBottom: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = Constant.bottomImage
        return view
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let attributedString = NSMutableAttributedString(string: "내가 만드는\n나만의 단어장,\n포잉포잉", attributes: [
            .font: UIFont.systemFont(ofSize: 38, weight: .light),
          .foregroundColor: UIColor.midnight,
          .kern: -1.0
        ])
        attributedString.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 38, weight: .black),
            range: NSRange(location: 16, length: 4)
        )
        label.attributedText = attributedString
        return label
    }()

    lazy var appleLoginButton: AppleLoginButton = {
        var button = AppleLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constant.Button.height * 0.5
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
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
            .foregroundColor: UIColor.brownGrey
        ]
        let attrString = NSMutableAttributedString(string: Constant.Terms.text, attributes: attributes)

        attrString.addAttribute(
            .foregroundColor,
            value: UIColor.slateGrey,
            range: Constant.Terms.privacyRange
        )

        attrString.addAttribute(
            .foregroundColor,
            value: UIColor.slateGrey,
            range: Constant.Terms.termsRange
        )

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
        label.isUserInteractionEnabled = true
        return label
    }()

    @objc func termsTapGesture(_ gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: Constant.Terms.privacyRange) {
            if let url = URL(string: Constant.Terms.privacyLink) {
                UIApplication.shared.open(url)
            }

        } else if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: Constant.Terms.termsRange) {
            if let url = URL(string: Constant.Terms.termsLink) {
                UIApplication.shared.open(url)
            }

        }
    }

    @objc func appleLoginDidTap(_ sender: UIButton) {
        AppleLoginHelper.shared.setDelegate(self)
        AppleLoginHelper.shared.handleAppleIdRequest()
    }

    func configureRx() {

    }

    func requestLogin(credential: String, name: String, email: String) {
        UserController.shared.login(credential: credential)
            .subscribe { [weak self] (response) in
                guard let self = self, let element = response.element else { return }
                if element.statusCode == 200 {
                    do {
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: element.data)
                        Token.shared.token = loginResponse.token
                        User.shared.userInfo = loginResponse.userResponse

                        UserDefaults.standard.setUserLoginIdentifier(indentifier: credential)
                        self.transitionToHome()
                    } catch {
                        // TODO: error
                    }
                } else {
                    
                    self.navigationController?.pushViewController(SignUpNameViewController(userIdentifier: credential, name: name), animated: true)
                }
            }
            .disposed(by: disposeBag)
    }

    private func transitionToHome() {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
          return
        }

        let viewController = UINavigationController(rootViewController: HomeViewController())

        window.rootViewController = viewController
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(
            with: window,
            duration: duration,
            options: options,
            animations: {},
            completion: nil)
    }

}

extension LoginViewController: LoginDelegate {
    func login(userIdentifier: String, name: String, email: String) {
        requestLogin(credential: userIdentifier, name: name, email: email)
    }
}

//
//  SignUpNameViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/13.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem
import PoingVocaSubsystem
import SnapKit
import KeyboardObserver
import RxSwift
import RxCocoa


class SignUpNameViewController: UIViewController {
    enum Constant {
        enum Confirm {
            static let sideMargin: CGFloat = 40
            static let height: CGFloat = 60
            enum Active {
                static let color: UIColor = .white
                static let backgroundColor: UIColor = .brightSkyBlue
            }
            enum InActive {
                static let color: UIColor = UIColor(white: 174.0 / 255.0, alpha: 1.0)
                static let backgroundColor: UIColor = .veryLightPink
            }
        }
        static let welcomeText = "반가워요!\n이름은 뭔가요?"
    }

    lazy var navView: SideNavigationView = {
        let view = SideNavigationView(
            leftImage: UIImage(named: "icArrow"),
            centerTitle: nil,
            rightImage: nil
        )
        view.leftSideButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .midnight
        label.numberOfLines = 0
        label.text = Constant.welcomeText
        return label
    }()

    lazy var nameTextField: AccentLineTextField = {
        let textField = AccentLineTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "이름"
        return textField
    }()

    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("완료", for: .normal)
        button.isEnabled = false
        button.backgroundColor = .veryLightPink
        button.setTitleColor(UIColor(white: 174.0 / 255.0, alpha: 1.0), for: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = Constant.Confirm.height * 0.5
        button.addTarget(self, action: #selector(confirmDidTap(_:)), for: .touchUpInside)
        return button
    }()

    private let disposeBag = DisposeBag()
    private let keyboard = KeyboardObserver()
    private var confirmButtonConstraint: NSLayoutConstraint?
    let userIdentifier: String

    init(userIdentifier: String, name: String) {
        self.userIdentifier = userIdentifier
        super.init(nibName: nil, bundle: nil)

        nameTextField.textField.text = name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureRx()
        observeKeyboard()
    }

    func configureLayout() {
        view.backgroundColor = .white

        view.addSubview(navView)
        view.addSubview(welcomeLabel)
        view.addSubview(nameTextField)
        view.addSubview(confirmButton)

        navView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        welcomeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom).offset(22)
            make.leading.equalTo(view).offset(16)
            make.trailing.lessThanOrEqualTo(view)
        }

        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(56)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }

        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.equalTo(Constant.Confirm.height)
            make.leading.equalTo(view).offset(Constant.Confirm.sideMargin)
            make.trailing.equalTo(view).offset(-Constant.Confirm.sideMargin)
        }

        confirmButtonConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: hasTopNotch ? 0 : -16)
        confirmButtonConstraint?.isActive = true
    }

    func updateConfirmButton() {
        confirmButton.backgroundColor = confirmButton.isEnabled
            ? Constant.Confirm.Active.backgroundColor
            : Constant.Confirm.InActive.backgroundColor
    }

    func configureRx() {
        nameTextField.textField.rx
            .controlEvent(.editingChanged)
            .subscribe { [weak self] (_) in
                guard let self = self,
                      let text = self.nameTextField.textField.text
                else { return }
                self.confirmButton.isEnabled = (text.count == 0) ? false : true
                self.updateConfirmButton()
            }.disposed(by: disposeBag)
    }

    func observeKeyboard() {
        keyboard.observe { [weak self] (event) -> Void in
            guard let self = self else { return }
            switch event.type {
            case .willShow, .willHide, .willChangeFrame:
                let keyboardFrameEnd = event.keyboardFrameEnd
                let bottom = keyboardFrameEnd.height - self.view.safeAreaInsets.bottom

                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options], animations: { () -> Void in
                    self.confirmButtonConstraint?.constant = -bottom - 16
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            default:
                break
            }
        }
    }

    func requestSignUp() {
        UserController.shared.signup(
            credential: userIdentifier,
            name: nameTextField.textField.text ?? ""
        )
        .subscribe { [weak self] (response) in
            guard let self = self, let element = response.element else { return }
            if element.statusCode == 200 {
                self.requestLogin(credential: self.userIdentifier)
            }
        }.disposed(by: disposeBag)
    }

    func requestLogin(credential: String) {
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

                    }
                }
            }.disposed(by: disposeBag)
    }

    @objc func tapLeftButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc func confirmDidTap(_ sender: UIButton) {
        // TODO: 가입 시도 callback
        requestSignUp()
    }

    func transitionToHome() {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
          return
        }

        let viewController = UINavigationController(rootViewController: HomeViewController())
        viewController.navigationBar.isHidden = true

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

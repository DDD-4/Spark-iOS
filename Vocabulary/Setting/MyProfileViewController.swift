//
//  MyProfileViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem
import SnapKit
import KeyboardObserver
import RxSwift
import RxCocoa

class MyProfileViewController: UIViewController {
    enum Constant {
        enum ProfileImage {
            static let topMargin: CGFloat = 32
            static let length: CGFloat = 166
        }
        enum Camera {
            static let length: CGFloat = 40
            static let image = UIImage(named: "icCamera")
        }
        enum Name {
            static let sideMargin: CGFloat = 32
            static let height: CGFloat = 56
        }
    }

    lazy var navView: SideNavigationView = {
        let view = SideNavigationView(
            leftImage: UIImage.init(named: "icArrow"),
            centerTitle: "프로필 수정",
            rightImage: UIImage(named: "btnCompleteDesabled")
        )
        view.leftSideButton.addTarget(self, action: #selector(closeDidTap(_:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "yellowFace")
        view.layer.cornerRadius = Constant.ProfileImage.length * 0.5
        view.clipsToBounds = true
        return view
    }()

    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constant.Camera.length * 0.5
        button.setImage(Constant.Camera.image, for: .normal)
        button.clipsToBounds = true
        return button
    }()

    lazy var nameTextField: VDSTextField = {
        let text = VDSTextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "홍길동"
        return text
    }()

    private let keyboard = KeyboardObserver()
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    private let disposeBag = DisposeBag()
    private var needAdjustScrollViewForTextFields = [UITextField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        observeKeyboard()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(gesture)

        needAdjustScrollViewForTextFields.append(nameTextField)
    }

    func configureLayout() {
        view.backgroundColor = .white

        view.addSubview(navView)
        view.addSubview(scrollView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(cameraButton)
        scrollView.addSubview(nameTextField)

        navView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.leading.trailing.equalTo(view)
        }

        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomConstraint?.isActive = true

        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView).offset(Constant.ProfileImage.topMargin)
            make.centerX.equalTo(view)
            make.width.height.equalTo(Constant.ProfileImage.length)
        }

        cameraButton.snp.makeConstraints { (make) in
            make.bottom.trailing.equalTo(profileImageView)
            make.width.height.equalTo(Constant.Camera.length)
        }

        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(27)
            make.leading.equalTo(view).offset(Constant.Name.sideMargin)
            make.trailing.equalTo(view).offset(-Constant.Name.sideMargin)
            make.height.equalTo(Constant.Name.height)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-16)
        }
    }

    @objc func viewTapped(_ gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }

    func observeKeyboard() {
        keyboard.observe { [weak self] (event) -> Void in
            guard let self = self else { return }
            switch event.type {
            case .willShow:
                let keyboardFrameEnd = event.keyboardFrameEnd
                let bottom = keyboardFrameEnd.height - self.view.safeAreaInsets.bottom

                self.scrollView.contentInset.bottom = bottom
                self.scrollView.verticalScrollIndicatorInsets.bottom = bottom
                
                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options], animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }) { _ in
                    self.adjustScrollViewOffset()
                }
            case .willHide:
                self.scrollView.contentInset.bottom = 0
                self.scrollView.verticalScrollIndicatorInsets.bottom = 0

                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options], animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }, completion: nil)
            default:
                break
            }
        }
    }

    private func adjustScrollViewOffset() {
        guard scrollView.contentSize.height > (scrollView.frame.size.height - scrollView.contentInset.bottom) else {
            return
        }

        for textField in needAdjustScrollViewForTextFields where textField.isFirstResponder {
            var offsetY: CGFloat = 0
            offsetY = textField.frame.maxY - (scrollView.frame.height - scrollView.contentInset.bottom)
            scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: offsetY), animated: true)
            break
        }
    }

    @objc func closeDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

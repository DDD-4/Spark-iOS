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
            static let font = UIFont.systemFont(ofSize: 20, weight: .bold)
            static let color = UIColor.midnight
            static let sideMargin: CGFloat = 32
        }
        enum Line {
            static let color = UIColor.grey244
            static let height: CGFloat = 1
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

    lazy var nameLabel: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "홍길동"
        text.font = Constant.Name.font
        text.textColor = Constant.Name.color
        text.tintColor = Constant.Name.color
        text.textAlignment = .center
        return text
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.Line.color
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    func configureLayout() {
        view.backgroundColor = .white

        view.addSubview(navView)
        view.addSubview(profileImageView)
        view.addSubview(cameraButton)
        view.addSubview(nameLabel)
        view.addSubview(lineView)

        navView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom).offset(Constant.ProfileImage.topMargin)
            make.centerX.equalTo(view)
            make.width.height.equalTo(Constant.ProfileImage.length)
        }

        cameraButton.snp.makeConstraints { (make) in
            make.bottom.trailing.equalTo(profileImageView)
            make.width.height.equalTo(Constant.Camera.length)
        }

        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(27)
            make.leading.equalTo(view).offset(Constant.Name.sideMargin)
            make.trailing.equalTo(view).offset(-Constant.Name.sideMargin)
        }

        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(Constant.Line.height)
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
    }

    @objc func closeDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

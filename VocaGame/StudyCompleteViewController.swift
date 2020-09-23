//
//  StudyCompleteViewController.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/09/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem
import SnapKit

public class StudyCompleteViewController: UIViewController {

    lazy var navView: SideNavigationView = {
        let view = SideNavigationView(
            leftImage: UIImage.init(named: "iconClose"),
            centerTitle: nil,
            rightImage: nil
        )
        view.leftSideButton.addTarget(self, action: #selector(closeDidTap(_:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "yellowFaceWithChat")
        return view
    }()

    lazy var confettiView: ConfettiView = {
        let view = ConfettiView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "학습 완료!"
        label.textColor = UIColor.midnight
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아쉬우면 다시 학습해볼까요?"
        label.textColor = UIColor.slateGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = UIColor.brightSkyBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("다시하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    }()

    @objc func closeDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureLayout()
    }

    func configureLayout() {
        view.addSubview(confettiView)
        view.addSubview(navView)
        view.addSubview(imageView)
        view.addSubview(titleStackView)
        view.addSubview(retryButton)

        navView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(220)
            make.height.equalTo(236)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(170)
            make.centerX.equalTo(view)
        }

        confettiView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view)
        }

        titleStackView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.leading.lessThanOrEqualTo(view)
            make.trailing.greaterThanOrEqualTo(view)
            make.centerX.equalTo(view)
        }

        retryButton.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(hasTopNotch ? 0 : -16)
        }
    }
}

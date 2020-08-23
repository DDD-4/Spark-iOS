//
//  NoticePopupViewController.swift
//  VocaDesignSystem
//
//  Created by LEE HAEUN on 2020/08/04.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//
//https://zpl.io/2jGvxl4

import UIKit

public class NoticePopupViewController: UIViewController {

    lazy var tapGestureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    public init(text: String) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        contentLabel.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureGesture()
    }

    func configureLayout() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6080639983)
        view.addSubview(contentView)
        contentView.addSubview(contentLabel)
        view.addSubview(tapGestureView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentView.heightAnchor.constraint(equalToConstant: 240),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            tapGestureView.topAnchor.constraint(equalTo: view.topAnchor),
            tapGestureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tapGestureView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tapGestureView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDidTap(_:)))
        tapGestureView.addGestureRecognizer(tapGesture)
    }

    @objc func tapDidTap(_ sender: UITapGestureRecognizer) {
        presentingViewController?.presentingViewController?.dismiss(
            animated: true,
            completion: nil
        )
    }
}

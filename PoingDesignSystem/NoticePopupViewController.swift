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
        contentLabel.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    func configureLayout() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        view.addSubview(contentView)
        contentView.addSubview(contentLabel)

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
        ])
    }
}

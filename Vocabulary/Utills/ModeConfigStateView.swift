//
//  ModeConfigStateView.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/19.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class ModeConfigStateViewController: UIViewController {
    lazy var modeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(modeDidTap), for: .touchUpInside)
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(modeButton)

        let mode = (ModeConfig.shared.currentMode == .offline)
            ? "offline mode"
            : "online mode"

        modeButton.setTitle(mode, for: .normal)
        NSLayoutConstraint.activate([
            modeButton.topAnchor.constraint(equalTo: view.topAnchor),
            modeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(modeConfigChanged(_:)),
            name: Notification.Name.modeConfig,
            object: nil
        )
    }

    @objc func modeDidTap(_ sender: UIButton) {
        ModeConfig.shared.currentMode = (ModeConfig.shared.currentMode == .offline)
            ? .online
            : .offline
    }

    @objc func modeConfigChanged(_ notification:Notification) {
        let mode = (ModeConfig.shared.currentMode == .offline)
            ? "offline mode"
            : "online mode"

        modeButton.setTitle(mode, for: .normal)
    }
}

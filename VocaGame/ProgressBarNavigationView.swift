//
//  ProgressBarNavigationView.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/08/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import PoingDesignSystem

class ProgressBarNavigationView: UIView {
    enum Constant {
        enum Close {
            static let height: CGFloat = 24
            static let image = UIImage(named: "icArrow")
        }
        enum Progress {
            static let backgroundColor: UIColor = .white
            static let progressColor: UIColor = .dandelion
            static let radius: CGFloat = 6
            static let height: CGFloat = 12
        }
    }

    private var maxCount: Int = 0
    private var progressWidthConstraint: NSLayoutConstraint?

    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constant.Close.image, for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    lazy var progressWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.Progress.backgroundColor
        view.layer.cornerRadius = Constant.Progress.radius
        return view
    }()

    lazy var progressBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.Progress.progressColor
        view.layer.cornerRadius = Constant.Progress.radius
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {

        addSubview(closeButton)
        addSubview(progressWrapper)
        progressWrapper.addSubview(progressBar)

        closeButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(Constant.Close.height)
            make.centerY.equalTo(self)
        }

        progressWrapper.snp.makeConstraints { (make) in
            make.leading.equalTo(closeButton.snp.trailing).offset(20)
            make.centerY.equalTo(self)
            make.height.equalTo(Constant.Progress.height)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-60)
        }
        progressWidthConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)
        progressWidthConstraint?.isActive = true

        progressBar.snp.makeConstraints { (make) in
            make.top.bottom.leading.height.equalTo(progressWrapper)
        }
    }

    func configire(maxCount: Int) {
        self.maxCount = maxCount
    }

    func setProgress(index: Int) {
        let progressWidth = self.progressWrapper.bounds.width/CGFloat(self.maxCount) * CGFloat(index)

        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self = self else { return }
            self.progressWidthConstraint?.constant = progressWidth
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

//
//  ScoreAnimateView.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/09/20.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem
import SnapKit

class ScoreAnimateView: UIView {
    enum Constant {
        enum Incorrect {
            static let duration: Double = 0.13
            static let image = UIImage(named: "imageFail")!
            static let shadow = Shadow(color: UIColor.orangered40, x: 0, y: 10, blur: 60)
        }
        enum Correct {
            static let duration: Double = 0.33
            static let image = UIImage(named: "imageSuccess")!
            static let shadow = Shadow(color: UIColor.goldenYellow40, x: 0, y: 10, blur: 60)
        }
    }

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    enum ScoreType {
        case Incorrect
        case Correct
    }

    let scoreType: ScoreType

    init(type: ScoreType) {
        scoreType = type
        super.init(frame: .zero)

        configureLayout()
        configureScoreStyle()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.centerY.equalTo(safeAreaLayoutGuide).offset(-10)
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.width.height.equalTo(220)
        }
    }

    func configureScoreStyle() {
        switch scoreType {
        case .Correct:
            imageView.layer.shadow(Constant.Correct.shadow)
            imageView.image = Constant.Correct.image
        case .Incorrect:
            imageView.layer.shadow(Constant.Incorrect.shadow)
            imageView.image = Constant.Incorrect.image
        }
    }

    func startAnimation(completeHandler: @escaping (() -> Void)) {
        stopAnimation()

        switch scoreType {
        case .Correct:
            correctAnimation {
                completeHandler()
            }
        case .Incorrect:
            incorrectAnimation {
                completeHandler()
            }
        }
    }

    func correctAnimation(completeHandler: @escaping (() -> Void)) {
        UIView.animate(
            withDuration: Constant.Correct.duration,
            delay: 0,
            options: [.curveEaseInOut]
        ) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1)
        } completion: { (_) in
            UIView.animate(
                withDuration: Constant.Correct.duration,
                delay: 0,
                options: [.curveEaseInOut]
            ) { [weak self] in
                guard let self = self else { return }
                self.imageView.transform = .identity
            } completion: { (_) in
                completeHandler()
            }
        }
    }

    func incorrectAnimation(completeHandler: @escaping (() -> Void)) {
        UIView.animate(
            withDuration: Constant.Incorrect.duration,
            delay: 0,
            options: [.curveEaseInOut]
        ) { [weak self] in
            guard let self = self else { return }

            self.imageView.transform = CGAffineTransform(translationX: -10, y: 0)
        } completion: { (_) in
            UIView.animate(
                withDuration: Constant.Incorrect.duration,
                delay: 0,
                options: [.curveEaseInOut]
            ) { [weak self] in
                guard let self = self else { return }
                self.imageView.transform = .identity
            } completion: { (_) in
                UIView.animate(withDuration: Constant.Incorrect.duration, delay: 0, options: [.curveEaseInOut]) {
                    self.imageView.transform = CGAffineTransform.identity.translatedBy(x: 10, y: 0)
                } completion: { (_) in
                    UIView.animate(
                        withDuration: Constant.Incorrect.duration,
                        delay: 0,
                        options: [.curveEaseInOut]
                    ) { [weak self] in
                        guard let self = self else { return }
                        self.imageView.transform = .identity
                    } completion: { (_) in
                        completeHandler()
                    }
                }
            }
        }

    }

    func stopAnimation() {
        self.imageView.transform = .identity
    }
}

//
//  SuccessPopUpViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/10/08.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import UIKit

public class SuccessPopupViewController: UIViewController {
    
    enum Constant {
        enum Image {
            static let height: CGFloat = 102
        }
        enum Popup {
            static let width: CGFloat = 263
            static let height: CGFloat = 156
            static let radius: CGFloat = 32
        }
        enum Label {
            static let sideMargin: CGFloat = 16
            static let bottomMargin: CGFloat = 32
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constant.Popup.radius
        return view
    }()
    
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "yellowFace")
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 6
        stack.axis = .vertical
        stack.alignment = .center
        
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "단어 만들기 완료!"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textColor = .midnight
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나의 단어장에서 확인할 수 있어요!"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.textColor = .slateGrey
        label.textAlignment = .center
        return label
    }()

    let completion: (() -> Void)?

    public init(title: String, message: String, completionHandler: (() -> Void)? = nil) {
        completion = completionHandler
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        descriptionLabel.text = message
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            self?.completion?()
        }
    }

    func initView() {
        view.backgroundColor = UIColor.midnight.withAlphaComponent(0.85)
        view.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: Constant.Popup.width),
            containerView.heightAnchor.constraint(equalToConstant: Constant.Popup.height),
           
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constant.Image.height),
            imageView.heightAnchor.constraint(equalToConstant: Constant.Image.height),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.Label.sideMargin),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constant.Label.sideMargin),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constant.Label.bottomMargin)
        ])
    }
    
}

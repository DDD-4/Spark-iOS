//
//  CanclePopupViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/09/19.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class SignOutPopupViewController: UIViewController {
    
    enum Constant {
        enum Image {
            static let height: CGFloat = 102
        }
        enum Popup {
            static let height: CGFloat = 290
            static let radius: CGFloat = 32
            static let sideMargin: CGFloat = 24
        }
        enum description {
            static let topMargin: CGFloat = 91
        }
        enum Button {
            static let height: CGFloat = 60
            static let radius: CGFloat = 30
        }
    }

    var hasTopNotch: Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constant.Popup.radius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "redFace")
        return view
    }()
    
    lazy var descriptionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 9
        stack.alignment = .center
        
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.textColor = .midnight
        view.text = "정말 떠나시나요?"
        view.textAlignment = .center
        view.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 26)
        
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.textColor = .slateGrey
        view.text = "탈퇴하시면 모든 활동 정보가 삭제됩니다."
        view.textAlignment = .center
        view.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        
        return view
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 7
        
        return stack
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constant.Button.radius
        button.setTitle("취소", for: .normal)
        button.backgroundColor = .grey244
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        button.setTitleColor(.midnight, for: .normal)
        
        button.addTarget(self, action: #selector(didCancelTap), for: .touchUpInside)
        
        return button
    }()
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constant.Button.radius
        button.setTitle("탈퇴할래요", for: .normal)
        button.backgroundColor = .brightSkyBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        
        button.addTarget(self, action: #selector(didConfirmTap), for: .touchUpInside)
        
        return button
    }()

    let completionHandler: ((Bool) -> Void)

    public init(titleMessege: String, descriptionMessege: String, completion: @escaping ((Bool) -> Void)) {

        completionHandler = completion

        super.init(nibName: nil, bundle: nil)

        self.titleLabel.text = titleMessege
        self.descriptionLabel.text = descriptionMessege

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
    
    func initView() {
        
        view.backgroundColor = UIColor.midnight.withAlphaComponent(0.85)
        view.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(descriptionStackView)
        containerView.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Constant.Popup.height),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constant.Image.height),
            
            descriptionStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constant.description.topMargin),
            descriptionStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.Popup.sideMargin) ,
            descriptionStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constant.Popup.sideMargin),
            
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.Popup.sideMargin),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constant.Popup.sideMargin),
            buttonStackView.heightAnchor.constraint(equalToConstant: Constant.Button.height),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: hasTopNotch ? 0 : -16),
            
        ])
        
    }
    
    @objc func didCancelTap(sender: UIButton) {
        completionHandler(false)
    }

    @objc func didConfirmTap(sender: UIButton) {
        completionHandler(true)
    }
    
}

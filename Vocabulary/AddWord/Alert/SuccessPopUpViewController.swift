//
//  SuccessPopUpViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/10/08.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SuccessPopupViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        //view.backgroundColor = .clear

        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        view.backgroundColor = UIColor.midnight.withAlphaComponent(0.85)
        view.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(Constant.Popup.width)
            make.height.equalTo(Constant.Popup.height)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(containerView.snp.centerX)
            make.centerY.equalTo(containerView.snp.top)
            make.width.height.equalTo(Constant.Image.height)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(containerView)
            make.leading.equalTo(containerView).offset(Constant.Label.sideMargin)
            make.trailing.equalTo(containerView).offset(-Constant.Label.sideMargin)
            make.bottom.equalTo(containerView.snp.bottom).offset(-Constant.Label.bottomMargin)
        }
    }
    
}

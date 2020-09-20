//
//  CanclePopupViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/09/19.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class CancelPopupViewController: UIViewController {
    
    enum state {
        case modal
        case navigation
    }
    
    enum Constant {
        enum Popup {
            static let height: CGFloat = 168
            static let width: CGFloat = 311
            static let radius: CGFloat = 32
        }
        enum Button {
            static let radius: CGFloat = 24
            static let margin: CGFloat = 24
        }
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constant.Popup.radius
        view.backgroundColor = .white
        return view
    }()
    lazy var announcementLabel: UILabel = {
        let view = UILabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 2
        
        view.textColor = .midnight
        view.text = "여기서 그만할까요?\n입력한 정보는 모두 사라져요."
        
        view.textAlignment = .center
        view.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        
        return view
    }()
    lazy var stackView: UIStackView = {
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
        return button
    }()
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constant.Button.radius
        button.setTitle("그만할래요", for: .normal)
        button.backgroundColor = .brightSkyBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        configureRx()
        
        // Do any additional setup after loading the view.
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
        containerView.addSubview(announcementLabel)
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(Constant.Popup.width)
            make.height.equalTo(Constant.Popup.height)
        }
        
        announcementLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.top).offset(Constant.Button.margin)
            make.leading.equalTo(containerView.snp.leading).offset(Constant.Button.margin)
            make.trailing.equalTo(containerView.snp.trailing).offset(-1 * Constant.Button.margin)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(containerView)
            make.leading.trailing.equalTo(announcementLabel)
            make.bottom.equalTo(containerView.snp.bottom).offset(-1 * Constant.Button.margin)
            make.height.equalTo(48)
            
        }
        
    }
    
    func configureRx() {
        cancelButton.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        confirmButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
}

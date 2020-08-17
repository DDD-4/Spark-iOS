//
//  VocaForAllNavigationView.swift
//  Vocabulary
//
//  Created by apple on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class VocaForAllNavigationView: UIView {
    enum Constant {
        enum Active {
            static let font = UIFont.systemFont(ofSize: 14, weight: .bold)
            static let backgroundColor = UIColor(red: 74.0 / 255.0, green: 191.0 / 255.0, blue: 1.0, alpha: 1.0)
            static let fontColor = UIColor.white
        }
        enum Inactive {
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let backgroundColor = UIColor(white: 244.0 / 255.0, alpha: 1.0)
            static let fontColor = UIColor(red: 127.0 / 255.0, green: 129.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0)
        }
        
        static let height: CGFloat = 36
    }
    // MARK: - Properties
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var sortPopularButton: BaseButton = {
        let button = BaseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("인기순", for: .normal)
        button.addTarget(self, action: #selector(popularSelected), for: .touchUpInside)
        button.backgroundColor = Constant.Active.backgroundColor
        button.setTitleColor(Constant.Active.fontColor, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.titleLabel?.font = Constant.Active.font
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var sortLatestButton: BaseButton = {
        let button = BaseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("최신순", for: .normal)
        button.addTarget(self, action: #selector(latestSelected), for: .touchUpInside)
        button.backgroundColor = Constant.Inactive.backgroundColor
        button.setTitleColor(Constant.Inactive.fontColor, for: .normal)
        button.titleLabel?.font = Constant.Inactive.font
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 15
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setAppearance()
    }
    
    // MARK: - View ✨
    func initView() {
        self.addSubview(containerView)
        //
        containerView.addSubview(sortPopularButton)
        containerView.addSubview(sortLatestButton)
        //
        containerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(22 + 36)
        }
        
        sortPopularButton.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView).offset(16)
            make.centerY.equalTo(containerView)
            make.height.equalTo(36)
        }
        
        sortLatestButton.snp.makeConstraints { (make) in
            make.leading.equalTo(sortPopularButton.snp.trailing).offset(10)
            make.centerY.equalTo(containerView)
            make.height.equalTo(36)
        }
    }
    
    func setAppearance() {
        self.backgroundColor = .white
        popularSelected()
    }
    
    @objc func popularSelected() {
        
        sortLatestButton.backgroundColor = Constant.Inactive.backgroundColor
        sortLatestButton.setTitleColor(Constant.Inactive.fontColor, for: .normal)
        sortLatestButton.titleLabel?.font = Constant.Inactive.font
        
        sortPopularButton.backgroundColor = Constant.Active.backgroundColor
        sortPopularButton.setTitleColor(Constant.Active.fontColor, for: .normal)
        sortPopularButton.titleLabel?.font = Constant.Active.font
        
    }
    
    @objc func latestSelected() {
        
        sortPopularButton.backgroundColor = Constant.Inactive.backgroundColor
        sortPopularButton.setTitleColor(Constant.Inactive.fontColor, for: .normal)
        sortPopularButton.titleLabel?.font = Constant.Inactive.font
        
        sortLatestButton.backgroundColor = Constant.Active.backgroundColor
        sortLatestButton.setTitleColor(Constant.Active.fontColor, for: .normal)
        sortLatestButton.titleLabel?.font = Constant.Active.font
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

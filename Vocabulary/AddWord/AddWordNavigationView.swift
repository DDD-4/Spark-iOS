//
//  AddWordNavigationView.swift
//  Vocabulary
//
//  Created by apple on 2020/07/29.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

private enum AddWordNavigationConstants {
  enum Title {
    static let Title: String = "단어 추가"
    static let color: UIColor = .black
    static let Font: UIFont = .systemFont(ofSize: 28, weight: .heavy)
  }
  enum Button {
    static let title: String = "취소"
    static let width: CGFloat = 34
    static let height: CGFloat = 34
    static let color: UIColor = .black
  }
  enum Divider {
    static let height: CGFloat = 4
    static let color: UIColor = .black
  }
}

class AddWordNavigationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setAppearance()
    }
    
    func initView() {
        self.addSubview(containerView)
    //
        containerView.addSubview(titleLabel)
        containerView.addSubview(settingButton)
    //
        containerView.snp.makeConstraints { (make) in
          make.top.leading.trailing.bottom.equalTo(self)
          make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { (make) in
          make.top.bottom.equalTo(containerView).offset(10)
          make.centerX.equalTo(containerView)
          make.centerY.equalTo(containerView)
          make.height.equalTo(24)
        }
        
        settingButton.snp.makeConstraints { (make) in
          make.trailing.equalTo(containerView).offset(-10)
          make.centerY.equalTo(titleLabel)
          make.top.bottom.equalTo(containerView).offset(10)
        }
        
      }
    
    func setAppearance() {
        self.backgroundColor = .white
        self.titleLabel.textColor = .black
        self.settingButton.setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var containerView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    lazy var titleLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = AddWordNavigationConstants.Title.color
      label.font = AddWordNavigationConstants.Title.Font
      label.text = AddWordNavigationConstants.Title.Title
      return label
    }()
    lazy var settingButton: BaseButton = {
      let button = BaseButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle(AddWordNavigationConstants.Button.title, for: .normal)
      return button
    }()
    
}

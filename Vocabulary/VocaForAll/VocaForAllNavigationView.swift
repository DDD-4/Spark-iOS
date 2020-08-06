//
//  VocaForAllNavigationView.swift
//  Vocabulary
//
//  Created by apple on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

private enum VocaForAllConstants {
  enum Title {
    static let Title: String = "모두의 단어장"
    static let color: UIColor = .black
    static let Font: UIFont = .systemFont(ofSize: 20, weight: .heavy)
  }
  enum Button {
    static let title: String = "최신순"
    static let width: CGFloat = 34
    static let height: CGFloat = 34
    static let color: UIColor = .black
  }
  enum Divider {
    static let height: CGFloat = 4
    static let color: UIColor = .black
  }
}
class VocaForAllNavigationView: UIView {
    
    // MARK: - Properties
    lazy var containerView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    lazy var titleLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = VocaForAllConstants.Title.color
      label.font = VocaForAllConstants.Title.Font
      label.text = VocaForAllConstants.Title.Title
      return label
    }()
    lazy var sortButton: BaseButton = {
      let button = BaseButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle(VocaForAllConstants.Button.title, for: .normal)
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
        containerView.addSubview(titleLabel)
        containerView.addSubview(sortButton)
    //
        containerView.snp.makeConstraints { (make) in
          make.top.leading.trailing.bottom.equalTo(self)
          make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { (make) in
          make.leading.equalTo(containerView).offset(20)
          make.centerY.equalTo(containerView)
          make.height.equalTo(29)
        }
        
        sortButton.snp.makeConstraints { (make) in
          make.trailing.equalTo(containerView).offset(-16)
          make.centerY.equalTo(containerView)
        }
        
      }
    
    func setAppearance() {
        self.backgroundColor = .white
        self.titleLabel.textColor = .black
        self.sortButton.setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  settingCell.swift
//  Vocabulary
//
//  Created by apple on 2020/08/04.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class SettingCell: UITableViewCell {
    static let reuseIdentifier = String(describing: SettingCell.self)

    enum Constant {
        enum Title {
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let color = UIColor.midnight
        }
        enum Line {
            static let color = UIColor(white: 244/255, alpha: 1)
            static let height: CGFloat = 1
        }
        enum Arrow {
            static let image = UIImage(named: "icSettingArrow")
        }
    }

    lazy var seperateLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.Line.color
        return view
    }()

    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = Constant.Arrow.image
        return imageView
    }()
    
    lazy var switchControl: UISwitch = {
       let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        // TODO: fix dummy data
        switchControl.isOn = true
        switchControl.onTintColor = .brightSkyBlue
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        clipsToBounds = false

        textLabel?.font = Constant.Title.font
        textLabel?.textColor = Constant.Title.color

        contentView.addSubview(seperateLineView)
        contentView.addSubview(switchControl)
        contentView.addSubview(arrowImageView)

        textLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView).offset(20)
            make.bottom.equalTo(contentView).offset(-20)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        })

        arrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
        }

        switchControl.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-16)
        }

        seperateLineView.snp.makeConstraints { (make) in
            make.height.equalTo(Constant.Line.height)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView)
        }
    }

    func configure(option: Option, isLast: Bool) {
        if let type = option.rightType {
            switch type {
            case .arrow:
                arrowImageView.isHidden = false
                switchControl.isHidden = true
            case .switch:
                arrowImageView.isHidden = true
                switchControl.isHidden = false
            }
        } else {
            arrowImageView.isHidden = true
            switchControl.isHidden = true
        }

        seperateLineView.isHidden = isLast
        textLabel?.text = option.title
    }

    @objc func handleSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            print("turn on")
        } else {
            print("turn off")
        }
    }
}

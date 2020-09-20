//
//  MyViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/08/04.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import PoingDesignSystem
import SnapKit
import RxCocoa
import RxSwift

class SettingViewController: UIViewController {
    enum Constant {
        enum Title {
            static let font = UIFont.systemFont(ofSize: 26, weight: .bold)
            static let color = UIColor.midnight
            static let text = "설정"
        }
        enum Floating {
            static let height: CGFloat = 60
        }
    }

    var options: [Option] = []

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.Title.text
        label.font = Constant.Title.font
        label.textColor = Constant.Title.color
        return label
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnCloseWhite"), for: .normal)
        button.layer.shadow(
            color: .greyblue20,
            alpha: 1,
            x: 0,
            y: 4,
            blur: 20,
            spread: 0
        )
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(closeButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(
            SettingCell.self,
            forCellReuseIdentifier: SettingCell.reuseIdentifier
        )
        tableView.register(
            SettingMyInfoCell.self,
            forCellReuseIdentifier: SettingMyInfoCell.reuseIdentifier
        )
        tableView.separatorStyle = .none
        tableView.contentInset.bottom = Constant.Floating.height + (hasTopNotch ? bottomSafeInset : 32)
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)

        // TODO: Binding data
        options = [
            Option(title: "복습 알림 설정", rightType: .switch, handler: {

            }),
            Option(title: "폴더 편집", rightType: .arrow, handler: { [weak self] in
                let viewController = EditMyFolderViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)

            }),
            Option(title: "로그아웃", rightType: nil, handler: {

            }),
            Option(title: "탈퇴하기", rightType: nil, handler: {

            }),
        ]

        #if DEBUG
        let option = Option(title: "모든 데이터 삭제하기 (only for dev)", rightType: nil, handler: {
            VocaManager.shared.deleteAllGroup()
            LoadCoreDataManager.shared.deleteLoadTime()
        })
        options.append(option)
        #endif

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    func configureLayout() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(closeButton)

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
            make.height.width.equalTo(Constant.Floating.height)
        }
    }

    @objc func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        switch section {
        case .profile:
            return 1
        case .options:
            return options.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch section {
        case .profile:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingMyInfoCell.reuseIdentifier,
                for: indexPath
                ) as? SettingMyInfoCell {
                cell.delegate = self
                return cell
            }
        case .options:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingCell.reuseIdentifier,
                for: indexPath
                ) as? SettingCell {
                cell.configure(
                option: options[indexPath.row],
                isLast: indexPath.row == options.count - 1)
                return cell
            }
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        switch section {
        case .profile:
            return
        case .options:
            options[indexPath.row].handler()
        }
    }
}

extension SettingViewController: SettingMyInfoCellDelegate {
    func settingMyInfoCell(_ cell: SettingMyInfoCell, didTapEdit button: UIButton) {
        navigationController?.pushViewController(MyProfileViewController(), animated: true)
    }
}

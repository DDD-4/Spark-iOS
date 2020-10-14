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
    private let disposeBag = DisposeBag()
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
                let viewController = PopupViewController(titleMessege: "로그아웃 하시겠어요?", descriptionMessege: "", cancelMessege: "취소", confirmMessege: "로그아웃")
                viewController.delegate = self
                viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: true, completion: nil)
            }),
            Option(title: "탈퇴하기", rightType: nil, handler: {
                let viewController = SignOutPopupViewController(titleMessege: "정말 떠나시나요?", descriptionMessege: "탈퇴하시면 모든 활동 정보가 삭제됩니다.")
                viewController.delegate = self
                viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: true, completion: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        getUserInfo()
        self.tableView.reloadData()
    }
    
    func getUserInfo() {
        UserController.shared.getUserInfo().subscribe { response in
            if !response.isCompleted {
                User.shared.userInfo = response.element
            }
        }.disposed(by: disposeBag)
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
                cell.configure(
                    profile: User.shared.userInfo?.photoUrl,
                    name: User.shared.userInfo?.name ?? ""
                )
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
    
    func transitionToLogin() {
        
        let loginViewController = LoginViewController()

        guard let window = UIApplication.shared.windows.first else {
          return
        }
        
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        window.rootViewController = navigationController
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

//로그아웃 delegate, 로그아웃시 토큰을 삭제하고 로그인 뷰로 전환한다.
extension SettingViewController: PopupViewDelegate {
    func didCancelTap(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func didConfirmTap(sender: UIButton) {
        Token.shared.token = nil
        
        self.dismiss(animated: true, completion: nil)
        self.transitionToLogin()
    }
}

extension SettingViewController: SignOutPopupViewDelegate {

    func didCancelSignOutTap(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didConfirmSignOutTap(sender: UIButton) {
        UserController.shared.deleteUser().subscribe { response in
            if response.element?.statusCode == 200 {
                UserDefaults.standard.setValue(nil, forKey: "LoginIdentifier")
                self.transitionToLogin()
            } else {
                //error
            }
        }.disposed(by: disposeBag)
    }
    
}

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
import VocaGame
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
//            Option(title: "복습 알림 설정", rightType: .switch, handler: {
//                
//            }),
            Option(title: "폴더 편집", rightType: .arrow, handler: { [weak self] in
                let viewController = EditMyFolderViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)

            }),
            Option(title: "고객센터", rightType: nil, handler: {
                if let url = URL(string: "https://www.notion.so/haeuncs/a71b86900fbe4544ae8b4c4d5a53922a") {
                    UIApplication.shared.open(url)
                }
            }),
            Option(title: "로그아웃", rightType: nil, handler: { [weak self] in
                let viewController = PopupViewController(
                    title: "로그아웃 하시겠어요?",
                    cancelMessege: "취소",
                    confirmMessege: "로그아웃"
                ) { bool in
                    if bool {
                        self?.resetUserDefaults()
                        self?.dismiss(animated: true, completion: nil)
                        self?.transitionToLogin()
                    } else {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
                self?.present(viewController, animated: true, completion: nil)
            }),
            Option(title: "탈퇴하기", rightType: nil, handler: { [weak self] in
                let viewController = SignOutPopupViewController(
                    titleMessege: "정말 떠나시나요?",
                    descriptionMessege: "탈퇴하시면 모든 활동 정보가 삭제됩니다."
                ) { bool in
                    if bool {
                        self?.requestLeaveAccount()
                    } else {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
                self?.present(viewController, animated: true, completion: nil)
            }),
        ]

        #if DEBUG
        let option = Option(title: "모든 데이터 삭제하기 (only for dev)", rightType: nil, handler: {
            VocaManager.shared.deleteAllGroup()
            LoadCoreDataManager.shared.deleteLoadTime()
        })
        options.append(option)
        #endif

        #if DEBUG
        let flipGuideOption = Option(title: "뒤집기 가이드 초기화 (only for dev)", rightType: nil, handler: {
            GameGuideUtill.reset()
        })
        options.append(flipGuideOption)
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

    func resetUserDefaults() {
        UserDefaults.flushUserInformation()
    }

    func requestLeaveAccount() {
        LoadingView.show()
        UserController.shared.deleteUser()
            .subscribe(onNext: { [weak self] (response) in
                LoadingView.hide()
                if response.statusCode == 200 {
                    self?.resetUserDefaults()
                    self?.transitionToLogin()
                } else {
                    //error
                }
            }, onError: { [weak self] (erroe) in
                LoadingView.hide()
                UIAlertController().presentShowAlert(
                    title: nil,
                    message: "네트워크 오류",
                    leftButtonTitle: "취소",
                    rightButtonTitle: "재시도"
                ) { (index) in
                    guard index == 1 else { return }
                    self?.requestLeaveAccount()
                }
            }).disposed(by: disposeBag)
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

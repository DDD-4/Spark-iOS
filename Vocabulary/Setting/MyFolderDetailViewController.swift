//
//  MyFolderDetailViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem
import PoingVocaSubsystem
import SnapKit
import KeyboardObserver
import RxSwift
import RxCocoa
import Moya

protocol MyFolderDetailViewControllerDelegate: class {
    func needFetchMyFolder(_ viewController: MyFolderDetailViewController)
}

class MyFolderDetailViewController: UIViewController {
    enum ViewType {
        case add
        case edit(folder: Folder)
    }

    public enum Constant {
        enum Confirm {
            static let height: CGFloat = 60
            static let minWidth: CGFloat = 206
            enum Active {
                static let color: UIColor = .white
                static let backgroundColor: UIColor = .brightSkyBlue
            }
            enum InActive {
                static let color: UIColor = UIColor(white: 174.0 / 255.0, alpha: 1.0)
                static let backgroundColor: UIColor = .veryLightPink
            }
            static let addText = "새 폴더 만들기"
            static let editText = "수정 완료"
        }

        enum TextField {
            static let placeholder = "새 폴더 이름 (15자 내외)"
        }

        enum VisivilityButton {
            static let spacing: CGFloat = 8
            static let inactiveImage = UIImage(named: "rectCheckboxDefault")
            static let activeImage = UIImage(named: "rectCheckboxChecked")
            static let length: CGFloat = 24

            static let text = "모두의 단어장에 공개하기"
            static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
            static let color = UIColor.slateGrey
        }

        enum Count {
            static let maxCount = 15
            static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
            static let color = UIColor.brownGrey
        }
    }

    private let disposeBag = DisposeBag()
    private let keyboard = KeyboardObserver()
    private var confirmButtonConstraint: NSLayoutConstraint?
    private var viewModel: MyFolderDetailViewModelType

    var delegate: MyFolderDetailViewControllerDelegate?

    lazy var navigationView: SideNavigationView = {
        let view = SideNavigationView(
            leftImage: UIImage.init(named: "icArrow"),
            centerTitle: nil,
            rightImage: nil
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftSideButton.addTarget(self, action: #selector(closeDidTap(_:)), for: .touchUpInside)
        return view
    }()

    lazy var textFieldView: AccentLineTextField = {
        let view = AccentLineTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 26, weight: .bold),
            .foregroundColor: UIColor.veryLightPink
        ]
        view.textField.attributedPlaceholder = NSAttributedString(
            string:Constant.TextField.placeholder,
            attributes: attributes
        )
        return view
    }()

    lazy var visibilityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constant.VisivilityButton.inactiveImage, for: .normal)
        button.setImage(Constant.VisivilityButton.activeImage, for: .selected)
        button.addTarget(self, action: #selector(visiblilityDidTap), for: .touchUpInside)
        return button
    }()

    lazy var visibilityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.VisivilityButton.text
        label.textColor = Constant.VisivilityButton.color
        label.font = Constant.VisivilityButton.font
        label.isUserInteractionEnabled = true
        return label
    }()


    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/15"
        label.font = Constant.Count.font
        label.textColor = Constant.Count.color
        return label
    }()


    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .veryLightPink
        button.setTitleColor(UIColor(white: 174.0 / 255.0, alpha: 1.0), for: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = Constant.Confirm.height * 0.5
        button.addTarget(self, action: #selector(confirmDidTap(_:)), for: .touchUpInside)
        return button
    }()

    let currentViewType: ViewType
    init(viewType: ViewType) {
        currentViewType = viewType
        switch viewType {
        case .add:
            viewModel = (ModeConfig.shared.currentMode == .offline)
                ?  MyFolderDetailViewModel()
                : MyFolderDetailOnlineViewModel()
        case .edit(let folder):
            viewModel = (ModeConfig.shared.currentMode == .offline)
                ? MyFolderDetailViewModel(editFolder: folder)
                :MyFolderDetailOnlineViewModel(editFolder: folder)
        }

        super.init(nibName: nil, bundle: nil)

        switch viewType {
        case .add:
            confirmButton.setTitle(Constant.Confirm.addText, for: .normal)
        case .edit(let folder):
            textFieldView.textField.text = folder.name
            confirmButton.setTitle(Constant.Confirm.editText, for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureRx()

        let visibilityTapGesture = UITapGestureRecognizer(target: self, action: #selector(visiblilityDidTap))
        visibilityLabel.addGestureRecognizer(visibilityTapGesture)

        observeKeyboard()
    }

    func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(textFieldView)
        view.addSubview(visibilityButton)
        view.addSubview(visibilityLabel)
        view.addSubview(countLabel)
        view.addSubview(confirmButton)

        navigationView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        textFieldView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationView.snp.bottom).offset(23)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }

        visibilityButton.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldView.snp.bottom).offset(16)
            make.leading.equalTo(view).offset(16)
            make.height.width.equalTo(Constant.VisivilityButton.length)
        }

        visibilityLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(visibilityButton.snp.trailing).offset(Constant.VisivilityButton.spacing)
            make.centerY.equalTo(visibilityButton)
            make.trailing.lessThanOrEqualTo(countLabel.snp.leading)
        }

        countLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(visibilityButton)
            make.trailing.equalTo(view).offset(-16)
        }

        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.equalTo(Constant.Confirm.height)
            make.width.greaterThanOrEqualTo(Constant.Confirm.minWidth)
        }

        confirmButtonConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: hasTopNotch ? 0 : -16)
        confirmButtonConstraint?.isActive = true

    }

    func updateConfirmButton() {
        confirmButton.backgroundColor = confirmButton.isEnabled
            ? Constant.Confirm.Active.backgroundColor
            : Constant.Confirm.InActive.backgroundColor
    }

    func configureRx() {
        textFieldView.textField.rx
            .controlEvent(.editingChanged)
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
                guard let text = self.textFieldView.textField.text else { return }
                if text.count > Constant.Count.maxCount {
                    self.textFieldView.textField.text = text[0..<Constant.Count.maxCount]
                }

                self.confirmButton.isEnabled = (text.count == 0) ? false : true

                self.updateConfirmButton()

                let count = self.textFieldView.textField.text?.count ?? 0
                self.countLabel.text = "\(count)/\(Constant.Count.maxCount)"
            }.disposed(by: disposeBag)
    }

    func observeKeyboard() {
        keyboard.observe { [weak self] (event) -> Void in
            guard let self = self else { return }
            switch event.type {
            case .willShow, .willHide, .willChangeFrame:
                let keyboardFrameEnd = event.keyboardFrameEnd
                let bottom = keyboardFrameEnd.height - self.view.safeAreaInsets.bottom

                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options], animations: { () -> Void in
                    self.confirmButtonConstraint?.constant = -bottom - 16
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            default:
                break
            }
        }
    }

    @objc func closeDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func visiblilityDidTap() {
        visibilityButton.isSelected = !visibilityButton.isSelected
    }

    @objc func confirmDidTap(_ sender: UIButton) {
        let folderName = textFieldView.textField.text ?? "이름 없음"
        switch currentViewType {
        case .add:
            viewModel.input.addFolder(
                name: folderName,
                isShareable: visibilityButton.isSelected) { [weak self] in
                guard let self = self else { return }
                self.delegate?.needFetchMyFolder(self)
                self.navigationController?.popViewController(animated: true)
            }
        case .edit(let folder):
            viewModel.input.editFolder(folder: folder, name: folderName, isShareable: visibilityButton.isSelected) { [weak self] in
                guard let self = self else { return }
                self.delegate?.needFetchMyFolder(self)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

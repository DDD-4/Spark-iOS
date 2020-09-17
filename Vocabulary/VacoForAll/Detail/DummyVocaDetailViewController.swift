//
//  DummyVocaDetailViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import PoingDesignSystem
import RxSwift
import RxCocoa
import SnapKit

class VocaForAllDetailViewController: UIViewController {
    enum Constant {
        enum Floating {
            static let height: CGFloat = 60
            static let width: CGFloat = 206
        }
        static let buttonRadius: CGFloat = 30
    }

    var headerHeightConstraint: NSLayoutConstraint?
    let maximumHeaderHeight: CGFloat = 130
    let minimumHeaderHeight: CGFloat = 0

    // MARK: - Properties
    lazy var naviView: SideNavigationView = {
        let view = SideNavigationView(leftImage: UIImage(named: "icArrow"), centerTitle: nil, rightImage: nil)
        view.backgroundColor = .white
        view.titleLabel.alpha = 0
        view.leftSideButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var headerView: VocaHeaderView = {
        let view = VocaHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var vocaCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical // 스크롤 방향
        flowLayout.minimumLineSpacing = 11 // 최소라인간격
        flowLayout.minimumInteritemSpacing = 11 // 최소 내부 여백
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: Constant.Floating.height + (hasTopNotch ? bottomSafeInset : 32),
            right: 16
        )
        collectionView.register(
            WordDetailCell.self,
            forCellWithReuseIdentifier: WordDetailCell.reuseIdentifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    lazy var saveButton: BaseButton = {
        let button = BaseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constant.buttonRadius
        button.setTitle("모두 저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        button.backgroundColor = .brightSkyBlue
        button.layer.masksToBounds = false
        return button
    }()

    let disposeBag = DisposeBag()
    let viewModel: WordViewModelType

    init(viewModel: WordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureRx()

        viewModel.input.fetchFolder()
    }

    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(vocaCollectionView)
        view.addSubview(naviView)
        view.addSubview(saveButton)

        let notchTopView = UIView()
        notchTopView.translatesAutoresizingMaskIntoConstraints = false
        notchTopView.backgroundColor = .white

        view.addSubview(notchTopView)

        notchTopView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(naviView.snp.top)
        }

        naviView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(naviView.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(57)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-57)
        }

        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: maximumHeaderHeight)
        headerHeightConstraint?.isActive = true

        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
            make.height.equalTo(Constant.Floating.height)
            make.width.equalTo(Constant.Floating.width)
        }

        vocaCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
    }

    func configureRx() {

        viewModel.input.content
            .subscribe { [weak self] (content) in
                guard let self = self, let data = content.element else { return }
                self.headerView.configure(
                    vocaTitle: data.folderName,
                    profileName: data.userName,
                    profileImage: nil
                )
                self.naviView.titleLabel.text = data.folderName
            }
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .withLatestFrom(viewModel.output.vocaContent)
            .subscribe(onNext: { [weak self] (vocaContent) in
                let viewController = SelectFolderViewController()
                viewController.delegate = self
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)

        viewModel.output.vocaContent
            .subscribe { [weak self] (response) in
                self?.vocaCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    @objc func tapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VocaForAllDetailViewController: SelectFolderViewControllerDelegate {
    func selectFolderViewController(didTapFolder folder: Group) {
        LoadingView.show()
        let words = viewModel.output.vocaContent.value
        let agent = VocaDownloadAgent(data: words)
        agent.download { [weak self] (words) in
            guard let self = self else {
                LoadingView.hide()
                return
            }

            VocaManager.shared.update(group: folder, addWords: words) {

                LoadingView.hide()

                // TODO: Add success alert (need design guide)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension VocaForAllDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let words = viewModel.output.vocaContent.value
        return words.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WordDetailCell.reuseIdentifier,
            for: indexPath
        ) as? WordDetailCell else {
            return UICollectionViewCell()
        }
        cell.configure(VocabularyContent: viewModel.output.vocaContent.value[indexPath.row])
        return cell
    }
}

extension VocaForAllDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - (11) - (16 * 2)) / 2
        return CGSize(width: width, height: 214)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == vocaCollectionView else {
            return
        }

        let y: CGFloat = scrollView.contentOffset.y
        let headerHeightConstant: CGFloat = headerHeightConstraint?.constant ?? 0
        let newHeaderHeight = headerHeightConstant - y

        if newHeaderHeight > maximumHeaderHeight {
            naviView.titleLabel.alpha = 0
            headerView.alpha = 1
            headerHeightConstraint?.constant = maximumHeaderHeight
        } else if newHeaderHeight < minimumHeaderHeight {
            naviView.titleLabel.alpha = 1
            headerView.alpha = 0
            headerHeightConstraint?.constant = minimumHeaderHeight
        } else {
            let ratio = newHeaderHeight / maximumHeaderHeight
            naviView.titleLabel.alpha = 1 - ratio
            headerView.alpha = ratio
            headerHeightConstraint?.constant = newHeaderHeight
            scrollView.contentOffset.y = 0
        }
    }
}


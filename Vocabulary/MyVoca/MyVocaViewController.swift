//
//  MyVocaViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import PoingVocaSubsystem
import PoingDesignSystem

class MyVocaViewController: UIViewController {

    let viewModel: MyVocaViewModelType = MyVocaViewModel()
    let disposeBag = DisposeBag()

    lazy var navigationViewArea: LeftTitleNavigationView = {
        let view = LeftTitleNavigationView(title: "미진이의 단어장", rightTitle: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var groupNameCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .gray
        collectionView.register(
            MyVocaGroupNameCell.self,
            forCellWithReuseIdentifier: MyVocaGroupNameCell.reuseIdentifier
        )
        collectionView.register(
            MyVocaWordCell.self,
            forCellWithReuseIdentifier: MyVocaWordCell.reuseIdentifier
        )
        collectionView.register(
            MyVocaGroupReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MyVocaGroupReusableView.reuseIdentifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    lazy var emptyWordView: EmptyWordView = {
        let view = EmptyWordView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        configureLayout()
        configureRx()

        viewModel.input.fetchGroups()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(vocaDataChanged),
            name: .vocaDataChanged,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let tabBarController = tabBarController as? TabbarViewController { tabBarController.hiddenTabBar(false)
        }
    }

    func configureLayout() {
        view.addSubview(navigationViewArea)
        view.addSubview(groupNameCollectionView)

        navigationViewArea.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        groupNameCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationViewArea.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

    }

    func configureRx() {

        viewModel.output.groups
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
            self?.groupNameCollectionView.reloadData()
        }).disposed(by: disposeBag)

        viewModel.output.words
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
            self?.groupNameCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }

    @objc
    func vocaDataChanged() {
        viewModel.input.fetchGroups()
    }

    func setWordEmptyView() {
        clearWordEmptyView()

        groupNameCollectionView.addSubview(emptyWordView)
        groupNameCollectionView.sendSubviewToBack(emptyWordView)

        emptyWordView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view)
        }
    }

    func clearWordEmptyView() {
        emptyWordView.removeFromSuperview()
    }
}

extension MyVocaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let wordCount = viewModel.output.words.value.count

        if wordCount == 0 {
            setWordEmptyView()
        } else {
            clearWordEmptyView()
        }

        return wordCount
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyVocaWordCell.reuseIdentifier, for: indexPath) as? MyVocaWordCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.configure(word: viewModel.output.words.value[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let reusableview = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: MyVocaGroupReusableView.reuseIdentifier,
                for: indexPath) as? MyVocaGroupReusableView else {
                    return UICollectionReusableView()
            }
            reusableview.delegate = self
            reusableview.configure(
                groups: viewModel.output.groups.value,
                selectedGroup: viewModel.input.selectedGroup.value
            )
            return reusableview
        default:
            return UICollectionReusableView()
        }
    }

}

extension MyVocaViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 444)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 20 + 36 + 20)
    }
}


extension MyVocaViewController: MyVocaViewControllerDelegate {
    func myVocaViewController(didTapEditGroupButton button: UIButton) {
        let editGroupViewController = EditMyVocaGroupViewController(groups: viewModel.output.groups.value)
        navigationController?.pushViewController(editGroupViewController, animated: true)
    }

    func myVocaViewController(didTapGroup group: Group, view: MyVocaGroupReusableView) {
        viewModel.input.selectedGroup.accept(group)
    }
}

extension MyVocaViewController: MyVocaWordCellDelegate {
    func MyVocaWord(didTapEdit button: UIButton, selectedWord word: Word) {

        let actionSheetData: [UIAlertAction] = [
            UIAlertAction(title: "단어 수정", style: .default, handler: { (_) in

            }),
            UIAlertAction(title: "단어 삭제", style: .destructive, handler: { [weak self] (_) in
                guard let group = self?.viewModel.input.selectedGroup.value else {
                    return
                }
                VocaManager.shared.update(group: group, deleteWords: [word])
            }),
            UIAlertAction(title: "닫기", style: .cancel, handler: { (_) in

            })
        ]

        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        for data in actionSheetData {
            actionsheet.addAction(data)
        }
        present(actionsheet, animated: true, completion: nil)
    }
}

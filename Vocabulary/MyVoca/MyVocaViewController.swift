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
    enum Constant {

    }

    let viewModel: MyVocaViewModelType = MyVocaViewModel()
    let disposeBag = DisposeBag()

    lazy var groupNameCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(
            MyVocaWordCell.self,
            forCellWithReuseIdentifier: MyVocaWordCell.reuseIdentifier
        )
        collectionView.register(
            MyVocaEmptyCell.self,
            forCellWithReuseIdentifier: MyVocaEmptyCell.reuseIdentifier
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        view.backgroundColor = .white

        view.addSubview(groupNameCollectionView)

        groupNameCollectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
}

extension MyVocaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let wordCount = viewModel.output.words.value.count
        return wordCount == 0 ? 1 : wordCount
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        print(viewModel.output.words.value)
        
        guard viewModel.output.words.value.count != 0 else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyVocaEmptyCell.reuseIdentifier, for: indexPath) as? MyVocaEmptyCell else {
                return UICollectionViewCell()
            }
            return cell
        }

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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 403)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 22 + 36)
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

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
import Voca

class MyVocaViewController: UIViewController {

    let viewModel = MyVocaViewModel()
    let disposeBag = DisposeBag()

    lazy var navigationViewArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        configureLayout()
        configureRx()

        viewModel.input.fetchGroups()
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
}

extension MyVocaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.words.value.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyVocaWordCell.reuseIdentifier, for: indexPath) as? MyVocaWordCell else {
            return UICollectionViewCell()
        }
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
            reusableview.configure(groups: viewModel.groups.value, selectedRow: 0)
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
        present(EditMyVocaGroupViewController(groups: viewModel.output.groups.value), animated: true, completion: nil)
    }

    func myVocaViewController(didTapGroup group: Group, view: MyVocaGroupReusableView) {
        viewModel.input.selectedGroup.onNext(group)
    }
}

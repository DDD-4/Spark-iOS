//
//  MyVocaGroupReusableView.swift
//  Vocabulary
//
//  Created by user on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import RxSwift

protocol MyVocaViewControllerDelegate: class {
    func myVocaViewController(didTapGroup group: Group, view: MyVocaGroupReusableView)
    func myVocaViewController(didTapEditGroupButton button: UIButton)
}
class MyVocaGroupReusableView: UICollectionReusableView {

    static let reuseIdentifier = String(describing: MyVocaGroupReusableView.self)
    weak var delegate: MyVocaViewControllerDelegate?

    private var groups = [Group]()
    private var selectedRow: Int?
    private let disposeBag = DisposeBag()

    lazy var groupNameCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MyVocaGroupNameCell.self,
            forCellWithReuseIdentifier: MyVocaGroupNameCell.reuseIdentifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .gray
        return collectionView
    }()

    lazy var groupEditButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("편집", for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLayout()
        bindRx()
        backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(groupNameCollectionView)
        addSubview(groupEditButton)

        groupNameCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalTo(self)
            make.height.equalTo(20 + 36 + 20)
        }

        groupEditButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(groupNameCollectionView.snp.centerY)
//            make.width.height.equalTo(24)
            make.trailing.equalTo(-16).priority(.high)
            make.leading.equalTo(groupNameCollectionView.snp.trailing).offset(16)
        }
    }

    func configure(groups: [Group], selectedGroup: Group?) {
        self.groups = groups
        for index in 0 ..< groups.count {
            if groups[index].identifier == selectedGroup?.identifier {
                selectedRow = index
            }
            break
        }

        groupNameCollectionView.reloadData()
    }
    func bindRx() {
        groupEditButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.delegate?.myVocaViewController(didTapEditGroupButton: self.groupEditButton)
        }).disposed(by: disposeBag)
    }
}

extension MyVocaGroupReusableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groups.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyVocaGroupNameCell.reuseIdentifier, for: indexPath) as? MyVocaGroupNameCell else {
            return UICollectionViewCell()
        }
        cell.configure(groupName: groups[indexPath.row].title)

        indexPath.row == selectedRow ? cell.selected() : cell.deSelected()
        return cell
    }
}

extension MyVocaGroupReusableView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cell = groups[indexPath.row]
        let size =  UILabel.measureSize(with: cell.title, font: UIFont.systemFont(ofSize: 12), width: .greatestFiniteMagnitude, numberOfLines: 1, lineBreakMode: .byTruncatingTail)

        return CGSize(width: size.width + 32, height: 36)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedRow != indexPath.row else {
            return
        }
        let beforeSelectedRow = selectedRow
        selectedRow = indexPath.row

        var reloadIndexPaths = [IndexPath]()
        reloadIndexPaths.append(indexPath)
        if let beforeSelectedRow = beforeSelectedRow {
            reloadIndexPaths.append(IndexPath(row: beforeSelectedRow, section: 0))
        }
        collectionView.reloadItems(at: reloadIndexPaths)

        delegate?.myVocaViewController(didTapGroup: groups[indexPath.row], view: self)
    }
}

//
//  MyVocaGroupReusableView.swift
//  Vocabulary
//
//  Created by user on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import Voca

protocol MyVocaViewControllerDelegate: class {
    func myVocaViewController(didTapGroup group: Group, view: MyVocaGroupReusableView)
}
class MyVocaGroupReusableView: UICollectionReusableView {

    static let reuseIdentifier = String(describing: MyVocaGroupReusableView.self)
    weak var delegate: MyVocaViewControllerDelegate?

    private var groups = [Group]()
    private var selectedRow: Int?

    lazy var groupNameCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLayout()
        backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(groupNameCollectionView)

        groupNameCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(self)
            make.height.equalTo(20 + 36 + 20)
        }
    }

    func configure(groups: [Group], selectedRow: Int) {
        self.groups = groups
        groupNameCollectionView.reloadData()
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

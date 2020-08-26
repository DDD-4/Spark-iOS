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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MyVocaGroupNameCell.self,
            forCellWithReuseIdentifier: MyVocaGroupNameCell.reuseIdentifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 22, left: 16, bottom: 0, right: 16)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        configureLayout()
        bindRx()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(groupNameCollectionView)

        groupNameCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(self)
            make.height.equalTo(22 + 36)
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
    }
}

extension MyVocaGroupReusableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groups.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyVocaGroupNameCell.reuseIdentifier,
            for: indexPath
            ) as? MyVocaGroupNameCell else {
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
        let size =  UILabel.measureSize(with: cell.title, font: MyVocaGroupNameCell.Constant.Active.font, width: .greatestFiniteMagnitude, numberOfLines: 1, lineBreakMode: .byTruncatingTail)

        return CGSize(width: size.width + 32, height: MyVocaGroupNameCell.Constant.height)
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}

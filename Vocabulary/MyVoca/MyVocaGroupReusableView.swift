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
    func myVocaViewController(didTapGroup group: Folder, view: MyVocaGroupReusableView)
    func myVocaViewController(didTapEditGroupButton button: UIButton)
    func myVocaGroupReusableView(didTapOrderType type: EveryVocaSortType, view: MyVocaGroupReusableView)
}

class MyVocaGroupReusableView: UICollectionReusableView {

    static let reuseIdentifier = String(describing: MyVocaGroupReusableView.self)
    weak var delegate: MyVocaViewControllerDelegate?

    private var groups = [Folder]()
    private var selectedRow: Int?

    private var orderTypes = [EveryVocaSortType]()
    private let disposeBag = DisposeBag()

    var currentViewType: MyVocaViewController.ViewType?

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
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
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

    func configure(groups: [Folder], selectedGroup: Folder?) {
        currentViewType = .myVoca
        self.groups = groups
        if let folder = groups as? [FolderCoreData],
           let selectedFolder = selectedGroup as? FolderCoreData {
            for index in 0 ..< folder.count where folder[index].identifier == selectedFolder.identifier {
                selectedRow = index
                break
            }
        } else {
            for index in 0 ..< groups.count where groups[index].id == selectedGroup?.id {
                selectedRow = index
                break
            }
        }

        groupNameCollectionView.reloadData()
    }

    func configure(orderTypes: [EveryVocaSortType], currentType: EveryVocaSortType?) {
        currentViewType = .vocaForAll
        self.orderTypes = orderTypes
        if let currentType = currentType {
            for index in 0 ..< orderTypes.count where orderTypes[index].key == currentType.key {
                selectedRow = index
                break
            }
        }

        groupNameCollectionView.reloadData()
    }

    func bindRx() {
    }
}

extension MyVocaGroupReusableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentViewType == .myVoca ? groups.count : orderTypes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewType = currentViewType,
            let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyVocaGroupNameCell.reuseIdentifier,
            for: indexPath
            ) as? MyVocaGroupNameCell else {
            return UICollectionViewCell()
        }

        switch viewType {
        case .myVoca:
            cell.configure(groupName: groups[indexPath.row].name)
        case .vocaForAll:
            cell.configure(groupName: orderTypes[indexPath.row].value)
        }

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
        guard let viewType = currentViewType else {
            return .zero
        }

        let string: String  = (viewType == .myVoca)
            ? groups[indexPath.row].name
            : orderTypes[indexPath.row].value
        
        let size =  UILabel.measureSize(
            with: string,
            font: MyVocaGroupNameCell.Constant.Active.font,
            width: .greatestFiniteMagnitude,
            numberOfLines: 1,
            lineBreakMode: .byTruncatingTail
        )

        return CGSize(
            width: size.width + 32,
            height: MyVocaGroupNameCell.Constant.height
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedRow != indexPath.row, let viewType = currentViewType else {
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

        switch viewType {
        case .myVoca:
            delegate?.myVocaViewController(didTapGroup: groups[indexPath.row], view: self)
        case .vocaForAll:
            delegate?.myVocaGroupReusableView(didTapOrderType: orderTypes[indexPath.row], view: self)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}

//
//  SelectFolderViewController.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/09/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem
import PoingVocaSubsystem
import SnapKit

public class SelectFolderViewController: UIViewController {
    enum Constant {
        static let spacing: CGFloat = 11
        enum Collection {
            static let topMargin: CGFloat = 44
        }
        enum Confirm {
            static let text = "복습하기"
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
        }
    }

    lazy var navView: SideNavigationView = {
        let view = SideNavigationView(
            leftImage: UIImage.init(named: "icArrow"),
            centerTitle: "복습할 폴더 선택",
            rightImage: nil
        )
        view.leftSideButton.addTarget(self, action: #selector(closeDidTap(_:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var folderCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = Constant.spacing
        flowLayout.minimumLineSpacing = Constant.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            SelectFolderCell.self,
            forCellWithReuseIdentifier: SelectFolderCell.reuseIdentifier
        )
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
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
        button.setTitle(Constant.Confirm.text, for: .normal)
        return button
    }()

    let folderList: [Folder]
    let selectedGameType: GameType

    var selectedIndexList: [Int] = []

    public init(_ folderList: [Folder], gameType: GameType) {
        self.folderList = folderList
        selectedGameType = gameType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(navView)
        view.addSubview(folderCollectionView)
        view.addSubview(confirmButton)

        navView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        folderCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }

        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.equalTo(Constant.Confirm.height)
            make.width.equalTo(Constant.Confirm.minWidth)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(hasTopNotch ? 0 : -16)
        }
    }

    @objc func closeDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func confirmDidTap(_ sender: UIButton) {
        var words = [Word]()

        if let folderCoreDataList = folderList as? [FolderCoreData] {
            for folder in folderCoreDataList {
                words.append(contentsOf: folder.words)
            }
        } else {

        }

        // TODO: ONLINE

        switch selectedGameType {
        case .flip:
            navigationController?.pushViewController(FlipGameViewController(words: words), animated: true)
        case .matching:
            navigationController?.pushViewController(CardMatchingViewController(words: words), animated: true)
        }
    }

    func updateConfirmButton() {
        confirmButton.isEnabled = selectedIndexList.isEmpty
            ? false
            : true
        confirmButton.backgroundColor = confirmButton.isEnabled
            ? Constant.Confirm.Active.backgroundColor
            : Constant.Confirm.InActive.backgroundColor
    }
}

extension SelectFolderViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderList.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectFolderCell.reuseIdentifier, for: indexPath) as! SelectFolderCell
        cell.configure(folder: folderList[indexPath.row])
        return cell
    }


}

extension SelectFolderViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectFolderCell else {
            return
        }
        if cell.radioButton.isSelected {
            cell.radioButton.isSelected = false
            for index in 0 ..< selectedIndexList.count where selectedIndexList[index] == indexPath.row {
                selectedIndexList.remove(at: index)
            }
        } else {
            cell.radioButton.isSelected = true
            selectedIndexList.append(indexPath.row)
        }

        updateConfirmButton()
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 32,
            left: 0,
            bottom:60 + (hasTopNotch ? bottomSafeInset : 32),
            right: 0
        )
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.frame.width - (11) - (16 * 2)) / 2
        return CGSize(width: width, height: width)
    }

}

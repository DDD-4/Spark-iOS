//
//  EditMyFolderViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem
import PoingDesignSystem

class EditMyFolderViewController: UIViewController {
    enum State {
        case delete
        case normal
    }

    private enum Constant {
        enum Floating {
            static let height: CGFloat = 60
        }
    }

    var viewModel: EditMyFolderViewModelType
    private var currentState: BehaviorRelay<State> = BehaviorRelay(value: .normal)
    private let disposeBag = DisposeBag()

    lazy var navigationViewArea: SideNavigationView = {
        let view = SideNavigationView(
            leftImage: UIImage(named: "icArrow"),
            centerTitle: "폴더 편집",
            rightImage: UIImage(named: "btnAdd")
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftSideButton.addTarget(self, action: #selector(dismissDidTap), for: .touchUpInside)
        return view
    }()

    lazy var groupCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            EditMyVocaGroupCell.self,
            forCellWithReuseIdentifier: EditMyVocaGroupCell.reuseIdentifier
        )
        collectionView.contentInset = UIEdgeInsets(
            top: 32,
            left: 0,
            bottom: hasTopNotch
                ? 32 + Constant.Floating.height
                : 16 + Constant.Floating.height,
            right: 0
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.backgroundColor = .whiteTwo
        collectionView.dragInteractionEnabled = true
        return collectionView
    }()

    lazy var addFolderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnAdd"), for: .normal)
        button.layer.shadow(
            color: .brightSkyBlue50,
            alpha: 1,
            x: 0,
            y: 5,
            blur: 20,
            spread: 0
        )
        button.layer.masksToBounds = false
        button.addTarget(nil, action: #selector(addDidTap(_:)), for: .touchUpInside)
        return button
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("삭제", for: .normal)
        button.backgroundColor = .veryLightPink
        button.setTitleColor(UIColor(white: 174.0 / 255.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(deleteGroupDidTap(_:)), for: .touchUpInside)
        return button
    }()

    init() {
        if ModeConfig.shared.currentMode == .offline {
            viewModel = EditMyFolderViewModel()
        } else {
            viewModel = EditMyFolderOnlineViewModel()
        }

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureRx()

        viewModel.input.fetchMyFolders()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(vocaDataChanged),
            name: .vocaDataChanged,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(modeConfigDidChanged),
            name: .modeConfig,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func configureLayout() {
        view.backgroundColor = .whiteTwo
        view.addSubview(navigationViewArea)
        view.addSubview(groupCollectionView)
        view.addSubview(addFolderButton)
        view.addSubview(deleteButton)

        navigationViewArea.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        groupCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationViewArea.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }

        addFolderButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
            make.height.width.equalTo(Constant.Floating.height)
        }

        deleteButton.snp.makeConstraints { (make) in
            let constant = MyFolderDetailViewController.Constant.Confirm.self
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
            make.height.equalTo(constant.height)
            make.width.greaterThanOrEqualTo(constant.minWidth)
        }
    }

    func configureRx() {

        viewModel.output.myFolders
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] (folders) in
                self?.groupCollectionView.reloadData()
            }
            .disposed(by: disposeBag)

        currentState
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .delete:
                    self.addFolderButton.isHidden = true
                    self.deleteButton.isHidden = false
                    self.navigationViewArea.rightSideButton.setImage(nil, for: .normal)
                    self.navigationViewArea.rightSideButton.setTitle("취소", for: .normal)
                    self.navigationViewArea.rightSideButton.setTitleColor(.black, for: .normal)
                    self.groupCollectionView.dragInteractionEnabled = false
                case .normal:
                    self.addFolderButton.isHidden = false
                    self.deleteButton.isHidden = true
                    self.navigationViewArea.rightSideButton.setImage(UIImage(named: "icDelete"), for: .normal)
                    self.navigationViewArea.rightSideButton.setTitle(nil, for: .normal)
                    self.groupCollectionView.dragInteractionEnabled = true
                }
            }).disposed(by: disposeBag)

        navigationViewArea.rightSideButton.rx.tap
            .withLatestFrom(currentState)
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                self.currentState.accept(state == .delete ? .normal : .delete)
                self.viewModel.input.deleteSelectedFolders.accept([])
                self.groupCollectionView.reloadData()
            }).disposed(by: disposeBag)

        viewModel.input.deleteSelectedFolders.subscribe(onNext: { [weak self] (groups) in
            guard let self = self else { return }
            let constant = MyFolderDetailViewController.Constant.Confirm.self
            if groups.isEmpty {
                self.deleteButton.setTitle("삭제", for: .normal)
                self.deleteButton.backgroundColor = constant.InActive.backgroundColor
                self.deleteButton.setTitleColor(constant.InActive.color, for: .normal)

            } else {
                self.deleteButton.setTitle("\(groups.count)개 삭제", for: .normal)
                self.deleteButton.backgroundColor = constant.Active.backgroundColor
                self.deleteButton.setTitleColor(constant.Active.color, for: .normal)

            }
            }).disposed(by: disposeBag)
    }

    @objc func deleteGroupDidTap(_ sender: UIButton) {
        guard viewModel.input.deleteSelectedFolders.value.isEmpty == false else {
            return
        }
        viewModel.input.deleteFolders(
            folders: viewModel.input.deleteSelectedFolders.value
        )

        self.currentState.accept(.normal)
    }

    @objc func addDidTap(_ sender: UIButton) {
        let myFolderDetailViewController = MyFolderDetailViewController(viewType: .add)
        myFolderDetailViewController.delegate = self

        navigationController?.pushViewController(myFolderDetailViewController, animated: true)
    }

    @objc func dismissDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func vocaDataChanged() {
        if ModeConfig.shared.currentMode == .offline {
            viewModel.input.fetchMyFolders()
        }
    }

    @objc func modeConfigDidChanged() {
        if ModeConfig.shared.currentMode == .offline {
            viewModel = EditMyFolderViewModel()
        } else {
            viewModel = EditMyFolderOnlineViewModel()
        }

        configureRx()
        viewModel.input.fetchMyFolders()
    }
}

extension EditMyFolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.output.myFolders.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EditMyVocaGroupCell.reuseIdentifier,
            for: indexPath
            ) as? EditMyVocaGroupCell else {
                return UICollectionViewCell()
        }

        cell.delegate = self

        if ModeConfig.shared.currentMode == .offline {
            if let myFolder = viewModel.output.myFolders.value[indexPath.row] as? FolderCoreData,
               let deleteSelectedGroup = viewModel.input.deleteSelectedFolders.value as? [FolderCoreData]
               {
                let isDeleteSelected = deleteSelectedGroup.contains { (selectedGroup) -> Bool in
                    selectedGroup.identifier == myFolder.identifier
                }
                cell.configure(
                    group: myFolder,
                    state: currentState.value,
                    isDeleteSelected: isDeleteSelected
                )
            }
        } else {
            let myFolder = viewModel.output.myFolders.value[indexPath.row]
            let isDeleteSelected = viewModel.input.deleteSelectedFolders.value.contains { (selectedGroup) -> Bool in
                selectedGroup.id == myFolder.id
            }
            cell.configure(
                group: myFolder,
                state: currentState.value,
                isDeleteSelected: isDeleteSelected
            )
        }
        return cell
    }
}

extension EditMyFolderViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 116)
    }
}

extension EditMyFolderViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = viewModel.output.myFolders.value[indexPath.row]
        let itemProvider = NSItemProvider(object: item.name as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension EditMyFolderViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(row: row - 1, section: 0)
        }

        if coordinator.proposal.operation == .move {
            reorderItems(collectionView, coordinator: coordinator, destinationIndexPath: destinationIndexPath)
        }
    }

    private func reorderItems(
        _ collectionView: UICollectionView,
        coordinator: UICollectionViewDropCoordinator,
        destinationIndexPath: IndexPath
    ) {
        guard let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath else {
            return
        }

        var tempGroup = viewModel.output.myFolders.value

        collectionView.performBatchUpdates({
            tempGroup.remove(at: sourceIndexPath.item)
            tempGroup.insert(item.dragItem.localObject as! Folder, at: destinationIndexPath.item)


            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])

            print(sourceIndexPath)
            print(destinationIndexPath)
            
            self.viewModel.output.myFolders.accept(tempGroup)
            if ModeConfig.shared.currentMode == .offline {
                viewModel.input.reorderFolders(sourceIndex: sourceIndexPath.section, destinationIndex: destinationIndexPath.section)
            } else {
                self.viewModel.input.reorderFolders(folders: tempGroup)
            }

        }) { (_) in
        }

        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
    }
}

extension EditMyFolderViewController: EditMyVocaGroupCellDelegate {
    func editMyVocaGroupCell(
        _ cell: UICollectionViewCell,
        didTapDeleteSelect button: UIButton,
        group: Folder
    ) {
        viewModel.input.addDeleteFolder(currentSelectedFolder: group)
    }

    func editMyVocaGroupCell(
        _ cell: UICollectionViewCell,
        didTapChangeVisibility button: UIButton,
        group: Folder
    ) {
        viewModel.input.changeVisibilityType(
            folder: group
        )
    }

    func editMyVocaGroupCell(
        _ cell: UICollectionViewCell,
        didTapEdit button: UIButton,
        folder: Folder
    ) {
        let myFolderDetailViewController = MyFolderDetailViewController(viewType: .edit(folder: folder))
        myFolderDetailViewController.delegate = self

        navigationController?.pushViewController(myFolderDetailViewController, animated: true)
    }
}

extension EditMyFolderViewController: MyFolderDetailViewControllerDelegate {
    func needFetchMyFolder(_ viewController: MyFolderDetailViewController) {
        viewModel.input.fetchMyFolders()
    }
}

//
//  EditMyVocaGroupViewController.swift
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

class EditMyVocaGroupViewController: UIViewController {
    enum State {
        case delete
        case normal
    }

    private enum Constant {
        enum Floating {
            static let height: CGFloat = 60
        }

        enum Delete {
            static let height: CGFloat = 60
            static let width: CGFloat = 206
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

    private var currentState: BehaviorRelay<State> = BehaviorRelay(value: .normal)
    let viewModel: EditMyVocaGroupViewModel
    let disposeBag = DisposeBag()
    var deleteSelectedGroup: BehaviorRelay<[Group]> = BehaviorRelay(value: [])

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
        collectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
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
        button.layer.cornerRadius = Constant.Delete.height * 0.5
        button.addTarget(self, action: #selector(deleteGroupDidTap(_:)), for: .touchUpInside)
        return button
    }()

    init(groups: [Group]) {
        viewModel = EditMyVocaGroupViewModel(groups: groups)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureRx()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(vocaDataChanged),
            name: .vocaDataChanged,
            object: nil
        )

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let tabBarController = tabBarController as? TabbarViewController {
            tabBarController.hiddenTabBar(true)
        }
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
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        addFolderButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
            make.height.width.equalTo(Constant.Floating.height)
        }

        deleteButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
            make.height.equalTo(Constant.Delete.height)
            make.width.equalTo(Constant.Delete.width)
        }
    }

    func configureRx() {
        currentState
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .delete:
                    self.addFolderButton.isHidden = true
                    self.deleteButton.isHidden = false
                    self.navigationViewArea.rightSideButton.setImage(nil, for: .normal)
                    self.navigationViewArea.rightSideButton.setTitle("삭제", for: .normal)
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
                self.deleteSelectedGroup.accept([])
                self.groupCollectionView.reloadData()
            }).disposed(by: disposeBag)

        deleteSelectedGroup.subscribe(onNext: { [weak self] (groups) in
            guard let self = self else { return }
            let constant = Constant.Delete.self
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
        guard deleteSelectedGroup.value.isEmpty == false else {
            return
        }

        for group in deleteSelectedGroup.value {
            VocaManager.shared.delete(group: group)
        }

        self.currentState.accept(.normal)
    }

    @objc func addDidTap(_ sender: UIButton) {
        present(AddVocaViewController(), animated: true, completion: nil)
    }

    @objc func dismissDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func vocaDataChanged() {
        viewModel.filteredFetchGroup() {
            self.groupCollectionView.reloadData()
        }
    }
}

extension EditMyVocaGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.groups.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EditMyVocaGroupCell.reuseIdentifier,
            for: indexPath
            ) as? EditMyVocaGroupCell else {
                return UICollectionViewCell()
        }
        let group = viewModel.groups.value[indexPath.row]
        
        cell.delegate = self
        let isDeleteSelected = deleteSelectedGroup.value.contains { (selectedGroup) -> Bool in
            selectedGroup.identifier == group.identifier
        }
        cell.configure(
            group: group,
            state: currentState.value,
            isDeleteSelected: isDeleteSelected
        )
        return cell
    }
}

extension EditMyVocaGroupViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 116)
    }
}

extension EditMyVocaGroupViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = viewModel.groups.value[indexPath.row]
        let itemProvider = NSItemProvider(object: item.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension EditMyVocaGroupViewController: UICollectionViewDropDelegate {
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

        var tempGroup = viewModel.groups.value

        collectionView.performBatchUpdates({
            tempGroup.remove(at: sourceIndexPath.item)
            tempGroup.insert(item.dragItem.localObject as! Group, at: destinationIndexPath.item)


            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])

            self.viewModel.groups.accept(tempGroup)

        }) { (_) in
        }

        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
    }
}

extension EditMyVocaGroupViewController: EditMyVocaGroupCellDelegate {
    func editMyVocaGroupCell(
        _ cell: UICollectionViewCell,
        didTapDeleteSelect button: UIButton,
        group: Group
    ) {
        var selectedGroupIndex: Int?
        var tempDeleteSelectedGroup = deleteSelectedGroup.value

        for index in 0..<tempDeleteSelectedGroup.count {
            if tempDeleteSelectedGroup[index].identifier == group.identifier {
                selectedGroupIndex = index
                break
            }
        }
        guard let index = selectedGroupIndex else {
            tempDeleteSelectedGroup.append(group)
            deleteSelectedGroup.accept(tempDeleteSelectedGroup)
            return
        }

        tempDeleteSelectedGroup.remove(at: index)
        deleteSelectedGroup.accept(tempDeleteSelectedGroup)
    }

    func editMyVocaGroupCell(
        _ cell: UICollectionViewCell,
        didTapDelete button: UIButton,
        group: Group
    ) {
        VocaManager.shared.delete(group: group)
    }

    func editMyVocaGroupCell(
        _ cell: UICollectionViewCell,
        didTapChangeVisibility button: UIButton,
        group: Group
    ) {
        let changedVisibilityType: VisibilityType = (group.visibilityType == .public) ? .private : .public

        var currentGroup = group

        currentGroup.visibilityType = changedVisibilityType

        VocaManager.shared.update(group: currentGroup)
    }
}

//
//  MyVocaViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import SnapKit
import PoingVocaSubsystem
import PoingDesignSystem

class MyVocaViewController: UIViewController {
    enum Constant {
        
    }
    
    enum ViewType {
        case myVoca
        case vocaForAll
    }

    // ViewModels
    var viewModel: MyVocaViewModelType

    let vocaForAllViewModel: VocaForAllViewModelType = VocaForAllViewModel()

    let currentViewType: ViewType
    
    let disposeBag = DisposeBag()
    let synthesizer = AVSpeechSynthesizer()
    
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
            VocaForAllCell.self,
            forCellWithReuseIdentifier: VocaForAllCell.reuseIdentifier
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
    
    init(viewType: ViewType) {
        currentViewType = viewType

        if ModeConfig.shared.currentMode == .offline {
            viewModel = MyVocaViewModel()
        } else {
            viewModel = MyVocaOnlineViewModel()
        }

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        
        switch currentViewType {
        case .myVoca:
            configureRx()
            viewModel.input.fetchFolder()
            
        case .vocaForAll:
            configureVocaForAllRx()
        }
        
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(myFolderDidChanged),
            name: PoingVocaSubsystem.Notification.Name.myFolder,
            object: nil
        )

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubview(groupNameCollectionView)
        
        groupNameCollectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
        
    }
    
    func configureRx() {
        viewModel.output.folders
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
    
    func configureVocaForAllRx() {
        vocaForAllViewModel.outputs.vocaForAllList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.groupNameCollectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    @objc func vocaDataChanged() {
        if ModeConfig.shared.currentMode == .offline {
            viewModel.input.fetchFolder()
        }
    }

    @objc func modeConfigDidChanged() {
        if ModeConfig.shared.currentMode == .offline {
            viewModel = MyVocaViewModel()
        } else {
            viewModel = MyVocaOnlineViewModel()
        }

        configureRx()
        viewModel.input.fetchFolder()
    }

    @objc func myFolderDidChanged() {
        if ModeConfig.shared.currentMode == .online {
            viewModel.output.folders.accept(FolderManager.shared.myFolders)
        }
    }
}

extension MyVocaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentViewType {
        case .myVoca:
            let wordCount = viewModel.output.words.value.count
            return wordCount == 0 ? 1 : wordCount
        case .vocaForAll:
            let type = vocaForAllViewModel.inputs.orderType.value
            switch type {
            case .popular, .recent:
                return vocaForAllViewModel.outputs.vocaForAllList.value.count
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch currentViewType {
        case.myVoca:
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
            let word = viewModel.output.words.value[indexPath.row]
            cell.configure(word: word)
            return cell
        case .vocaForAll:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VocaForAllCell.reuseIdentifier,
                for: indexPath
                ) as? VocaForAllCell else {
                    return UICollectionViewCell()
            }

            let type = vocaForAllViewModel.inputs.orderType.value
            switch type {
            case .popular, .recent:
                cell.configure(content: vocaForAllViewModel.outputs.vocaForAllList.value[indexPath.item])
            }
            return cell
        }
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
            switch currentViewType {
            case .myVoca:
                reusableview.configure(
                    groups: viewModel.output.folders.value,
                    selectedGroup: viewModel.input.selectedFolder.value
                )
            case .vocaForAll:
                let test = VocaForAllOrderType.allCases
                reusableview.configure(
                    orderTypes: test,
                    currentType: vocaForAllViewModel.inputs.orderType.value
                )
            }
            return reusableview
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard currentViewType == .vocaForAll else { return }

        let type = vocaForAllViewModel.inputs.orderType.value

        switch type {
        case .popular, .recent:
            let selectedFolder = vocaForAllViewModel.outputs.vocaForAllList.value[indexPath.row]
            let viewModel = VocaForAllDetailViewModel(content: selectedFolder)
            let wordView = VocaForAllDetailViewController(viewModel: viewModel)

            navigationController?.pushViewController(wordView, animated: true)
        }
    }
}

extension MyVocaViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 24,
            left: 0,
            bottom: HomeViewController.Constant.Floating.height + (hasTopNotch ? bottomSafeInset : 32),
            right: 0
        )
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        currentViewType == .myVoca
            ? CGSize(width: collectionView.frame.width, height: 403)
            : CGSize(width: collectionView.frame.width, height: 343)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 22 + 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        currentViewType == .myVoca ? 20 : 16
    }
}


extension MyVocaViewController: MyVocaViewControllerDelegate {
    func myVocaGroupReusableView(didTapOrderType type: VocaForAllOrderType, view: MyVocaGroupReusableView) {
        vocaForAllViewModel.inputs.orderType.accept(type)
    }
    
    func myVocaViewController(didTapEditGroupButton button: UIButton) {
        let editGroupViewController = EditMyFolderViewController()
        navigationController?.pushViewController(editGroupViewController, animated: true)
    }
    
    func myVocaViewController(didTapGroup group: Folder, view: MyVocaGroupReusableView) {
        viewModel.input.selectedFolder.accept(group)
    }
}

extension MyVocaViewController: MyVocaWordCellDelegate {
    func myVocaWord(didTapEdit button: UIButton, selectedWord word: Word) {
        let actionSheetData: [UIAlertAction] = [
            UIAlertAction(
                title: "단어 수정",
                style: .default,
                handler: { [weak self] (_) in
                    let viewController = DetailWordViewController(
                        group: self?.viewModel.input.selectedFolder.value,
                        word: word
                    )

                    self?.present(viewController, animated: true, completion: nil)
                }
            ),

            UIAlertAction(
                title: "단어 삭제",
                style: .destructive,
                handler: { [weak self] (_) in
                    self?.viewModel.input.deleteWord(deleteWords: [word])
                }
            ),

            UIAlertAction(
                title: "닫기",
                style: .cancel,
                handler: { _ in }
            )
        ]
        
        let actionsheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertController.Style.actionSheet
        )
        
        for data in actionSheetData {
            actionsheet.addAction(data)
        }

        present(actionsheet, animated: true, completion: nil)
    }
    
    func myVocaWord(didTapMic button: UIButton, selectedWord word: Word) {
        let englishWord = word.english
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: englishWord)
        utterance.rate = 0.3
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}

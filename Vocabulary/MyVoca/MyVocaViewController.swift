//
//  MyVocaViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import AVFoundation
import PoingVocaSubsystem
import PoingDesignSystem
import RxSwift
import RxCocoa
import SnapKit

class MyVocaViewController: UIViewController {
    enum Constant {
        enum Floating {
            static let height: CGFloat = 60
        }
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

    var currentSynthesizerCellRow: Int?
    var currentSynthesizerCellRowList: [Int] = []
    
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

    lazy var addWordFloatingButton: UIButton = {
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
        return button
    }()

    lazy var gameFloatingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnGame"), for: .normal)
        button.layer.shadow(
            color: .greyblue50,
            alpha: 1,
            x: 0,
            y: 5,
            blur: 20,
            spread: 0
        )
        button.layer.masksToBounds = false
        return button
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
            configureMyVoca()
            configureRx()
            viewModel.input.fetchFolder()
            viewModel.input.getWord(page: 0)
            
        case .vocaForAll:
            configureVocaForAllRx()
            vocaForAllViewModel.inputs.fetchEveryVocaSortTypes()
        }
        
        self.synthesizer.delegate = self

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(vocaDataChanged),
            name: PoingVocaSubsystem.Notification.Name.wordUpdate,
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(folderUpdate),
            name: PoingVocaSubsystem.Notification.Name.folderUpdate,
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

    func configureMyVoca() {
        view.addSubview(addWordFloatingButton)
        view.addSubview(gameFloatingButton)

        addWordFloatingButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
            make.height.width.equalTo(Constant.Floating.height)
        }

        gameFloatingButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.height.width.equalTo(Constant.Floating.height)
        }
    }
    
    func configureRx() {
        addWordFloatingButton.rx.tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                let viewController = TakePictureViewController()
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.navigationBar.isHidden = true
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalTransitionStyle = .coverVertical
                self?.present(navigationController, animated: true, completion: nil)
            }).disposed(by: disposeBag)

        gameFloatingButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                let navigationController = UINavigationController(rootViewController: GameViewController())
                navigationController.navigationBar.isHidden = true
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalTransitionStyle = .coverVertical
                self?.present(navigationController, animated: true, completion: nil)
            }).disposed(by: disposeBag)

        viewModel.input.selectedFolder
            .subscribe(onNext: { [weak self] (folders) in
                guard folders != nil else { return }
                self?.viewModel.input.getWord(page: self?.viewModel.input.currentPage.value ?? 0)
                self?.groupNameCollectionView.reloadData()
            }).disposed(by: disposeBag)

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
        
        vocaForAllViewModel.outputs.everyVocaSortTypes
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.groupNameCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        vocaForAllViewModel.outputs.vocaShouldShowLoadingCell
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (bool) in
                bool ? LoadingView.show() : LoadingView.hide()
            }).disposed(by: disposeBag)
    }
    
    @objc func vocaDataChanged() {
        viewModel.input.getWord(page: 0)
    }
    
    @objc func modeConfigDidChanged() {
        if ModeConfig.shared.currentMode == .offline {
            viewModel = MyVocaViewModel()
        } else {
            viewModel = MyVocaOnlineViewModel()
        }
        
        configureRx()
        configureVocaForAllRx()
        viewModel.input.fetchFolder()
        viewModel.input.getWord(page: 0)
    }
    
    @objc func myFolderDidChanged() {
        if ModeConfig.shared.currentMode == .online {
            viewModel.output.folders.accept(FolderManager.shared.myFolders)
            viewModel.input.currentPage.accept(0)
        }
    }

    @objc func folderUpdate() {
        if ModeConfig.shared.currentMode == .online {
            viewModel.input.fetchFolder()
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
            return vocaForAllViewModel.outputs.vocaForAllList.value.count
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
            cell.tag = indexPath.item
            return cell
        case .vocaForAll:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VocaForAllCell.reuseIdentifier,
                for: indexPath
            ) as? VocaForAllCell else {
                return UICollectionViewCell()
            }
            cell.configure(content: vocaForAllViewModel.outputs.vocaForAllList.value[indexPath.item])
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
                reusableview.configure(
                    orderTypes: vocaForAllViewModel.outputs.everyVocaSortTypes.value,
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
        
        let selectedFolder = vocaForAllViewModel.outputs.vocaForAllList.value[indexPath.row]
        let viewModel = VocaForAllDetailViewModel(content: selectedFolder)
        let wordView = VocaForAllDetailViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(wordView, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch currentViewType {
        case .myVoca:
            guard indexPath.row == (viewModel.output.words.value.count - 1),
                  viewModel.output.hasMoreContent() else {
                return
            }
            
            let value = viewModel.input.currentPage.value
            viewModel.input.currentPage.accept(value + 1)
        case .vocaForAll:
            guard indexPath.row == (vocaForAllViewModel.outputs.vocaForAllList.value.count - 1),
                  vocaForAllViewModel.outputs.hasMoreEveryVocaContent()
            else { return }
            
            let value = vocaForAllViewModel.inputs.currentPage.value
            
            vocaForAllViewModel.inputs.currentPage.accept(value + 1)
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
    func myVocaGroupReusableView(didTapOrderType type: EveryVocaSortType, view: MyVocaGroupReusableView) {
        vocaForAllViewModel.inputs.orderType.accept(type)
    }
    
    func myVocaViewController(didTapEditGroupButton button: UIButton) {
        let editGroupViewController = EditMyFolderViewController()
        navigationController?.pushViewController(editGroupViewController, animated: true)
    }
    
    func myVocaViewController(didTapGroup group: Folder, view: MyVocaGroupReusableView) {
        viewModel.input.selectedFolder.accept(group)
        viewModel.input.getWord(page: 0)
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
                        group: self?.viewModel.input.selectedFolder.value ?? self?.viewModel.output.folders.value.first,
                        word: word
                    )
                    
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.navigationBar.isHidden = true
                    navigationController.modalPresentationStyle = .fullScreen
                    navigationController.modalTransitionStyle = .coverVertical
                    self?.present(navigationController, animated: true, completion: nil)
                    
                }
            ),
            
            UIAlertAction(
                title: "단어 삭제",
                style: .destructive,
                handler: { [weak self] (_) in
                    self?.viewModel.input.deleteWord(deleteWords: [word]) { [weak self] in
                        guard let self = self else { return }
                        let alert: UIAlertView = UIAlertView(title: "단어 삭제 완료!", message: "단어장에 단어를 삭제했어요!", delegate: nil, cancelButtonTitle: nil);
                        
                        alert.show()
                        
                        let when = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: when){
                            alert.dismiss(withClickedButtonIndex: 0, animated: true)
                            
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }
                    }
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
    
    func myVocaWord(_ cell: UICollectionViewCell, didTapMic button: UIButton, selectedWord word: Word) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        guard let cell = cell as? MyVocaWordCell else {
            return
        }

        stopAnimation { [weak self] in
            guard let self = self else { return }
            self.synthesizer.stopSpeaking(at: .immediate)
            self.currentSynthesizerCellRow = cell.tag
            let englishWord = word.english
            let utterance = AVSpeechUtterance(string: englishWord)
            utterance.rate = 0.3
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            self.synthesizer.speak(utterance)
        }
            do {
                self.disableAVSession()
            }
    }

    private func disableAVSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't disable.")
        }
    }

}
extension MyVocaViewController: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        if let row = currentSynthesizerCellRow,
           let currentCell = groupNameCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? MyVocaWordCell {
            currentCell.startAnimation()

            currentSynthesizerCellRowList.append(row)
            currentSynthesizerCellRow = nil
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        stopAllAnimation()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        stopAllAnimation()
    }

    func stopAnimation(completion: (() -> Void)? = nil) {
        if currentSynthesizerCellRowList.isEmpty == false,
           let currentRow = currentSynthesizerCellRowList.first,
           let currentCell = groupNameCollectionView.cellForItem(at: IndexPath(row: currentRow, section: 0)) as? MyVocaWordCell {
            currentCell.stopAnimation()
            currentSynthesizerCellRowList.removeFirst()
        }
        completion?()
    }

    func stopAllAnimation() {
        for row in currentSynthesizerCellRowList {
            if let currentCell = groupNameCollectionView.cellForItem(
                at: IndexPath(row: row, section: 0)
            ) as? MyVocaWordCell {
                currentCell.stopAnimation()
            }
        }

        currentSynthesizerCellRowList = []
    }
}

extension MyVocaViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
    }
}

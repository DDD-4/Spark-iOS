//
//  MyVocaOnlineViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/18.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

class MyVocaOnlineViewModel:
    MyVocaViewModelInput,
    MyVocaViewModelOutput,
    MyVocaViewModelType {
    
    let disposeBag = DisposeBag()
    
    var words: BehaviorRelay<[Word]>
    var folders: BehaviorRelay<[Folder]>
    
    var selectedFolder: BehaviorRelay<Folder?>
    var selectedFolderIndex: BehaviorRelay<Int?>
    
    var input: MyVocaViewModelInput { return self }
    var output: MyVocaViewModelOutput { return self }
    var currentPage: BehaviorRelay<Int>
    var vocaShouldShowLoadingCell: BehaviorRelay<Bool>
    var vocaHasMore: BehaviorRelay<Bool>
    
    init() {
        words = BehaviorRelay<[Word]>(value: [])
        selectedFolder = BehaviorRelay<Folder?>(value: nil)
        folders = BehaviorRelay<[Folder]>(value: [])
        selectedFolderIndex = BehaviorRelay<Int?>(value: nil)
        
        vocaHasMore = BehaviorRelay<Bool>(value: false)
        currentPage = BehaviorRelay<Int>(value: 0)
        vocaShouldShowLoadingCell = BehaviorRelay<Bool>(value: false)
        
        currentPage.bind { [weak self] page in
            guard let self = self else { return }
            
            //currentPage.accept(page)
            self.getWord(page: page)
        }.disposed(by: disposeBag)

        folders
            .bind { [weak self] (folders) in
                if folders.count > 0 {
                    self?.selectedFolder.accept(folders.first)
                } else {
                    self?.selectedFolder.accept(nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func hasMoreContent() -> Bool {
        vocaHasMore.value && vocaShouldShowLoadingCell.value == false
    }

    func fetchFolder() {
        LoadingView.show()
        FolderController.shared.getMyFolder()
            .subscribe(onNext: { [weak self] (response) in
                LoadingView.hide()
                self?.folders.accept(response)
                self?.words.accept([])
                FolderManager.shared.myFolders = response
            }, onError: { [weak self] (error) in
                LoadingView.hide()
                UIAlertController().presentShowAlert(
                    title: "네트워크 오류",
                    message: "\(error.localizedDescription)",
                    leftButtonTitle: "취소",
                    rightButtonTitle: "재시도"
                ) { (index) in
                    guard index == 1 else { return }
                    self?.fetchFolder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func deleteWord(deleteWords: [Word], completion: @escaping (() -> Void)) {
        LoadingView.show()
        WordController.shared.deleteWord(vocabularyId: deleteWords[0].id).subscribe { response in
            LoadingView.hide()
            if response.element?.statusCode == 200 {
                NotificationCenter.default.post(name: PoingVocaSubsystem.Notification.Name.wordUpdate, object: nil)
                completion()
            } else {
                //error
            }
        }
        .disposed(by: disposeBag)
    }
    
    func getWord(page: Int) {
        LoadingView.show()
        vocaShouldShowLoadingCell.accept(true)
        WordController.shared.getWord(folderId: self.selectedFolder.value?.id ?? 0, page: page)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] response in
                LoadingView.hide()
                self?.vocaShouldShowLoadingCell.accept(false)
                guard let self = self, let element = response.element else { return }
                
                if page == 0 {
                    self.words.accept(element.content)
                } else {
                    self.words.accept(self.words.value + element.content)
                }
                self.vocaHasMore.accept(element.hasNext)
            }.disposed(by: disposeBag)
    }
}

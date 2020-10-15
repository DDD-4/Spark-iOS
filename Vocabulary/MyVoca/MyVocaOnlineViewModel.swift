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
        FolderController.shared.getMyFolder()
            .subscribe({ [weak self] (response) in
                guard let element = response.element else {
                    return
                }
                self?.folders.accept(element)
                FolderManager.shared.myFolders = element
            })
            .disposed(by: disposeBag)
    }
    
    func deleteWord(deleteWords: [Word], completion: @escaping (() -> Void)) {
        WordController.shared.deleteWord(vocabularyId: deleteWords[0].id).subscribe { response in
            if response.element?.statusCode == 200 {
                NotificationCenter.default.post(name: PoingVocaSubsystem.Notification.Name.folderUpdate, object: nil)
                completion()
            } else {
                //error
            }
        }
        .disposed(by: disposeBag)
    }
    
    func getWord(page: Int) {
        vocaShouldShowLoadingCell.accept(true)
        WordController.shared.getWord(folderId: self.selectedFolder.value?.id ?? 0, page: page)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] response in
                self?.vocaShouldShowLoadingCell.accept(false)
                guard let self = self, let element = response.element else {
                    return
                }
                self.words.accept(element.content)
            }
    }
}

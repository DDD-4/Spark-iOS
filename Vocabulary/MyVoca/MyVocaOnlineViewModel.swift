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
    
    init() {
        words = BehaviorRelay<[Word]>(value: [])
        selectedFolder = BehaviorRelay<Folder?>(value: nil)
        folders = BehaviorRelay<[Folder]>(value: [])
        selectedFolderIndex = BehaviorRelay<Int?>(value: nil)

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
    
    private func fetchWordByFolderId() {
        // TODO: Need Word network code
    }
    
    func getWord() {
        WordController.shared.getWord(folderId: self.selectedFolder.value?.id ?? 1)
            .map({ (words) -> [Word] in
                WordManager.shared.myWord = words.content
                return words.content
            }).subscribe{ [weak self] (words) in
                self?.words.accept(words)
            }.disposed(by: disposeBag)
    }
}

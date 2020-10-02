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

class MyVocaOnlineViewModel: MyVocaViewModelInput, MyVocaViewModelOutput, MyVocaViewModelType {
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

    func deleteWord(deleteWords: [Word]) {
        let folderIds = deleteWords.map { (word) -> Int in
            word.id
        }
        FolderController.shared.deleteFolder(folderId: folderIds)
            .bind { [weak self] _ in
                // TODO: Need callback
            }
            .disposed(by: disposeBag)
    }

    private func fetchWordByFolderId() {
        // TODO: Need Word network code
    }
}

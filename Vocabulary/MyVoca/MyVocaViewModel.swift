//
//  MyVocaViewModel.swift
//  Vocabulary
//
//  Created by user on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

protocol MyVocaViewModelOutput {
    var folders: BehaviorRelay<[Folder]> { get }
    var words: BehaviorRelay<[Word]> { get }
}

protocol MyVocaViewModelInput {
    func fetchFolder()
    func deleteWord(deleteWords: [Word], completion: @escaping ( () -> Void))
    func getWord()
    var selectedFolderIndex: BehaviorRelay<Int?> { get }
    var selectedFolder: BehaviorRelay<Folder?> { get }
}

protocol MyVocaViewModelType {
    var input: MyVocaViewModelInput { get }
    var output: MyVocaViewModelOutput { get }
}

class MyVocaViewModel: MyVocaViewModelInput, MyVocaViewModelOutput, MyVocaViewModelType {
    let disposeBag = DisposeBag()

    var words: BehaviorRelay<[Word]>

    var selectedFolder: BehaviorRelay<Folder?>

    var folders: BehaviorRelay<[Folder]>

    var selectedFolderIndex: BehaviorRelay<Int?>

    var input: MyVocaViewModelInput { return self }
    var output: MyVocaViewModelOutput { return self }


    init() {
        words = BehaviorRelay<[Word]>(value: [])
        selectedFolder = BehaviorRelay<Folder?>(value: nil)
        folders = BehaviorRelay<[Folder]>(value: [])
        selectedFolderIndex = BehaviorRelay<Int?>(value: nil)

        selectedFolder.map { (group) -> [Word] in
            guard let folder = group as? FolderCoreData else {
                return []
            }
            return folder.words
        }
        .bind(to: words)
        .disposed(by: disposeBag)
    }

    func fetchFolder() {
        VocaManager.shared.fetch(identifier: nil) { [weak self] (groups) in
            guard let self = self else { return }
            guard let groups = groups, groups.isEmpty == false else {
                self.folders.accept([])
                return
            }
            self.folders.accept(groups)

            var currentSelectedGroup: [Folder] = []
            if let folderCoreData = self.selectedFolder.value as? FolderCoreData {
                currentSelectedGroup = groups.filter { (group) -> Bool in
                    group.identifier == folderCoreData.identifier
                }
            }

            if currentSelectedGroup.isEmpty == false {
                self.selectedFolder.accept(currentSelectedGroup.first)
            } else {
                self.selectedFolder.accept(groups.first!)
            }
        }
    }

    func deleteWord(deleteWords: [Word], completion: @escaping (() -> Void)) {
        guard let folder = selectedFolder.value as? FolderCoreData,
              let deleteWords = deleteWords as? [WordCoreData] else {
            return
        }

        VocaManager.shared.update(group: folder, deleteWords: deleteWords) { [weak self] in
            completion()
        }
    }
    
    func getWord() {
        
    }
}

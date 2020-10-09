//
//  DetailWordViewModel.swift
//  Vocabulary
//
//  Created by apple on 2020/09/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PoingVocaSubsystem

class DetailWordViewModel: DetailWordViewModelInput, DetailWordViewModelOutput, DetailWordViewModelType {
    
    
    var updateWord: BehaviorRelay<WordCoreData?>
    
    var updateFolder: BehaviorRelay<FolderCoreData?>

    var input: DetailWordViewModelInput { return self }

    var output: DetailWordViewModelOutput { return self}

    let disposeBad = DisposeBag()

    init(editFolder: FolderCoreData? = nil, word: WordCoreData? = nil) {
        self.updateWord = BehaviorRelay(value: word)
        self.updateFolder = BehaviorRelay(value: editFolder)
    }
    
    func postWord(
        folder: Folder,
        word: Word,
        image: Data,
        completion: @escaping (() -> Void)
    ) {
        
        guard let folder = folder as? FolderCoreData else {
            return
        }
        var wordOrder = folder.words.count ?? 0
        guard let postWord = word as? WordCoreData else {
            return
        }
        
        VocaManager.shared.update(
            group: folder,
            addWords: [postWord]) { [weak self] in
            completion()
        }
    }
    
    func updateWord(
        vocabularyId: Int,
        deleteFolder: Folder,
        addFolder: Folder,
        deleteWords: [Word],
        addWords: [Word],
        completion: @escaping (() -> Void)
    ) {
        
        guard let deleteFolder = deleteFolder as? FolderCoreData,
              let addFolder = addFolder as? FolderCoreData,
              let deleteWord = deleteWords[0] as? WordCoreData,
              let addWord = addWords[0] as? WordCoreData else {
            return
        }
        
        VocaManager.shared.update(
            deleteGroup: deleteFolder,
            addGroup: addFolder,
            deleteWords: [deleteWord],
            addWords: [addWord]
        ) { [weak self ] in
            completion()
        }
    }
    
    func deleteWord(
        vocabularyId: Int,
        word: Word,
        completion: @escaping (() -> Void)
    ) {
        
    }

}

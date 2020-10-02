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
        folderId: Int,
        word: WordCoreData,
        completion: @escaping (() -> Void)
    ) {
        guard let folder = self.updateFolder.value else {
            return
        }
        var wordOrder = folder.words.count ?? 0
        
        VocaManager.shared.update(
            group: folder,
            addWords: [word]) { [weak self] in
            completion()
        }
    }
    
    func updateWord(
        vocabularyId: Int,
        deleteFolder: FolderCoreData,
        addFolder: FolderCoreData,
        deleteWords: [WordCoreData],
        addWords: [WordCoreData],
        completion: @escaping (() -> Void)
    ) {
        VocaManager.shared.update(
            deleteGroup: deleteFolder,
            addGroup: addFolder,
            deleteWords: deleteWords,
            addWords: addWords
        ) { [weak self ] in
            completion()
        }
    }
    
    func deleteWord(
        vocabularyId: Int,
        word: WordCoreData,
        completion: @escaping (() -> Void)
    ) {
        
    }

}

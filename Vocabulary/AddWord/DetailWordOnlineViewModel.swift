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

protocol DetailWordViewModelInput {
    
    func postWord(
        folderId: Int,
        word: WordCoreData,
        completion: @escaping (() -> Void))
    
    func updateWord(
        vocabularyId: Int,
        deleteFolder: FolderCoreData,
        addFolder: FolderCoreData,
        deleteWords: [WordCoreData],
        addWords: [WordCoreData],
        completion: @escaping (() -> Void))
    
    func deleteWord(
        vocabularyId: Int,
        word: WordCoreData,
        completion: @escaping (() -> Void))
    
}

protocol DetailWordViewModelOutput {
    
}

protocol DetailWordViewModelType {
    var input: DetailWordViewModelInput { get }
    var output: DetailWordViewModelOutput { get }
}

class DetailWordOnlineViewModel: DetailWordViewModelInput, DetailWordViewModelOutput, DetailWordViewModelType {
    
    var updateWord: BehaviorRelay<Word?>
    
    var input: DetailWordViewModelInput { return self }
    
    var output: DetailWordViewModelOutput { return self }
    
    let disposeBag = DisposeBag()
    
    init(updateWord: Word? = nil) {
        self.updateWord = BehaviorRelay(value: updateWord)
    }
    
    func postWord(
        folderId: Int,
        word: WordCoreData,
        completion: @escaping (() -> Void)
    ) {
        WordController.shared.postWord(
            english: word.english,
            folderId: word.id,
            korean: word.korean,
            photo: word.image! )
            .subscribe{ response in
                if response.element?.statusCode == 200 {
                    completion()
                } else {
                    //error
                    print("postWord error")
                }
            }.disposed(by: disposeBag)
    }
    
    func updateWord(
        vocabularyId: Int,
        deleteFolder: FolderCoreData,
        addFolder: FolderCoreData,
        deleteWords: [WordCoreData],
        addWords: [WordCoreData],
        completion: @escaping (() -> Void)
    ) {
        guard !addWords.isEmpty else {
            print("no updated Words")
            return
        }
        
        WordController.shared.updateWord(
            vocabularyId: vocabularyId,
            english: addWords[0].english,
            folderId: addWords[0].id,
            korean: addWords[0].korean,
            photo: addWords[0].image!
        )
        .subscribe { (response) in
            if response.element?.statusCode == 200 {
                completion()
            } else {
                // error
                print("updateWord error")
            }
        }.disposed(by: disposeBag)
    }
    
    func deleteWord(
        vocabularyId: Int,
        word: WordCoreData,
        completion: @escaping (() -> Void)
    ) {
        WordController.shared.deleteWord(vocabularyId: vocabularyId)
            .subscribe { response in
                if response.element?.statusCode == 200 {
                    completion()
                } else {
                    //error
                    print("deleteWord error")
                }
            }.disposed(by: disposeBag)
    }
    
}

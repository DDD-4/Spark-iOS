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
        folder: Folder,
        word: Word,
        image: Data,
        completion: @escaping (() -> Void))
    
    func updateWord(
        vocabularyId: Int,
        deleteFolder: Folder,
        addFolder: Folder,
        deleteWords: [Word],
        addWords: [Word],
        completion: @escaping (() -> Void))
    
    func deleteWord(
        vocabularyId: Int,
        word: Word,
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
        folder: Folder,
        word: Word,
        image: Data,
        completion: @escaping (() -> Void)
    ) {
        
        WordController.shared.postWord(
            english: word.english,
            folderId: folder.id,
            korean: word.korean,
            photo: image
        )
            .subscribe{ response in
                
                if response.element?.statusCode == 200 {
                    completion()
                } else {
                    //error 처리 해줘야함
                    print("postWord error")
                }
            }.disposed(by: disposeBag)
    }
    
    func updateWord(
        vocabularyId: Int,
        deleteFolder: Folder,
        addFolder: Folder,
        deleteWords: [Word],
        addWords: [Word],
        completion: @escaping (() -> Void)
    ) {
        guard !addWords.isEmpty else {
            print("no updated Words")
            return
        }
        
        guard let addWord = addWords[0] as? WordCoreData else {
            return
        }
        
        guard let image = addWord.image else {
            return
        }
        
        WordController.shared.updateWord(
            vocabularyId: vocabularyId,
            english: addWord.english,
            folderId: addFolder.id,
            korean: addWord.korean,
            photo: image
        )
        .subscribe { (response) in
            if response.element?.statusCode == 200 {
                completion()
            } else {
                // error
                print(response)
            }
        }.disposed(by: disposeBag)
    }
    
    func deleteWord(
        vocabularyId: Int,
        word: Word,
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

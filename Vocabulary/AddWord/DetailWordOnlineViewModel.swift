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
    func addWord(
        folder: Folder,
        english: String,
        korean: String,
        image: Data,
        completion: @escaping (() -> Void)
    )
    
    func updateWord(
        deleteFolder: Folder,
        addFolder: Folder,
        updateWord: Word,
        korean: String,
        english: String,
        image: Data,
        completion: @escaping (() -> Void)
    )
    
    func deleteWord(
        vocabularyId: Int,
        word: Word,
        completion: @escaping (() -> Void)
    )
    
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
    
    func addWord(
        folder: Folder,
        english: String,
        korean: String,
        image: Data,
        completion: @escaping (() -> Void)
    ) {
        LoadingView.show()
        WordController.shared.postWord(
            english: english,
            folderId: folder.id,
            korean: korean,
            photo: image
        )
        .subscribe(onNext: { (response) in
            LoadingView.hide()
            if response.statusCode == 200 {
                NotificationCenter.default.post(name: PoingVocaSubsystem.Notification.Name.wordUpdate, object: nil)
                completion()
            } else {
                //error 처리 해줘야함
                print("postWord error")
                completion()
            }
        }, onError: { (error) in
            LoadingView.hide()
            completion()
        }).disposed(by: disposeBag)
    }
    
    func updateWord(
        deleteFolder: Folder,
        addFolder: Folder,
        updateWord: Word,
        korean: String,
        english: String,
        image: Data,
        completion: @escaping (() -> Void)
    ) {

        LoadingView.show()
        WordController.shared.updateWord(
            vocabularyId: updateWord.id,
            english: english,
            folderId: addFolder.id,
            korean: korean,
            photo: image
        )
        .subscribe(onNext: { (response) in
            LoadingView.hide()
            if response.statusCode == 200 {
                NotificationCenter.default.post(name: PoingVocaSubsystem.Notification.Name.wordUpdate, object: nil)
                completion()
            } else {
                // error
                print(response)
            }
        }, onError: { (error) in
            LoadingView.hide()
        }).disposed(by: disposeBag)
    }
    
    func deleteWord(
        vocabularyId: Int,
        word: Word,
        completion: @escaping (() -> Void)
    ) {
        LoadingView.show()
        WordController.shared.deleteWord(vocabularyId: vocabularyId)
            .subscribe(onNext: { [weak self] (response) in
                LoadingView.hide()
                if response.statusCode == 200 {
                    NotificationCenter.default.post(name: PoingVocaSubsystem.Notification.Name.wordUpdate, object: nil)
                    completion()
                } else {
                    //error
                    print("deleteWord error")
                }
            }, onError: { (error) in
                LoadingView.hide()
            }).disposed(by: disposeBag)
    }
    
}

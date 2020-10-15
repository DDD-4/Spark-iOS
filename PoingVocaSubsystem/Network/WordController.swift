//
//  WrodController.swift
//  PoingVocaSubsystem
//
//  Created by apple on 2020/09/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import RxSwift
import Moya

extension Notification.Name {
    public static let myWord = Notification.Name("MyWord")
}

public class WordManager {
    public static let shared = WordManager()
    
    public var myWord: [Word] = [] {
        didSet {
            NotificationCenter.default.post(
                name: Notification.Name.myWord,
                object: nil
            )
        }
    }
}

public class WordController {
    public static let shared = WordController()
    private let serviceManager = WordServiceManager()
    
    public func getWord(folderId: Int, page: Int = 0) -> Observable<WordResponse> {
        serviceManager.providerWithToken.rx
            .request(WordService.getWord(folderId: folderId, page: page))
            .map {
                try JSONDecoder().decode(WordResponse.self, from: $0.data)
            }.asObservable()
    }
    
    public func postWord(
        english: String,
        folderId: Int,
        korean: String,
        photo: Data
    ) -> Observable<Response> {
        serviceManager.providerWithToken.rx
            .request(WordService.postWord(english: english, folderId: folderId, korean: korean, photo: photo))
            .asObservable()
    }
    
    public func deleteWord(vocabularyId: Int) -> Observable<Response> {
        serviceManager.providerWithToken.rx
            .request(WordService.deleteWord(vocabularyId: vocabularyId))
            .asObservable()
    }

    public func updateWord(
        vocabularyId: Int,
        english: String,
        folderId: Int,
        korean: String,
        photo: Data
    ) -> Observable<Response> {
        serviceManager.providerWithToken.rx
            .request(WordService.updateWord(vocabularyId: vocabularyId, english: english, folderId: folderId, korean: korean, photo: photo))
            .asObservable()
        
    }
}

//
//  EveryVocabularyController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import RxSwift

public class EveryVocabularyController {
    public static let shared = EveryVocabularyController()
    private let serviceManager = EveryVocabularyServiceManager()

    public func getEveryVocabularies() -> Observable<EveryVocaResponse> {
        return serviceManager.provider.rx
            .request(EveryVocabularyService.getEveryVocabularies)
            .map(EveryVocaResponse.self)
            .asObservable()
    }

    public func getEveryVocabulariesFolder(folderId: Int) -> Observable<[WordResponse]> {
        return serviceManager.provider.rx
            .request(EveryVocabularyService.getEveryVocabulariesFolder(folderId: folderId))
            .map([WordResponse].self)
            .asObservable()
    }
}

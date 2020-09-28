//
//  EveryVocabularyController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import RxSwift
import Moya

public class EveryVocabularyController {
    public static let shared = EveryVocabularyController()
    private let serviceManager = EveryVocabularyServiceManager()

    public func getEveryVocabularies(sortType: EveryVocabularySortType) -> Observable<EveryVocaResponse> {
        return serviceManager.provider.rx
            .request(EveryVocabularyService.getEveryVocabularies(sortType: sortType))
            .map(EveryVocaResponse.self)
            .asObservable()
    }

    public func getEveryVocabulariesFolder(folderId: Int) -> Observable<[Word]> {
        return serviceManager.provider.rx
            .request(EveryVocabularyService.getEveryVocabulariesFolder(folderId: folderId))
            .map([Word].self)
            .asObservable()
    }

    public func downloadFolder(downloadFolderId: Int, myFolderId: Int) -> Observable<Response> {
        return serviceManager.provider.rx
            .request(EveryVocabularyService.getEveryVocabulariesDownload(downloadFolderId: downloadFolderId, myFolderId: myFolderId))
            .asObservable()
    }
}

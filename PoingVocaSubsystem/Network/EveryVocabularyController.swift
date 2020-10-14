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

    public func getEveryVocabulariesSortType() -> Observable<[EveryVocaSortType]> {
        return serviceManager.providerWithToken.rx
            .request(EveryVocabularyService.getEveryVocabulariesSortType)
            .map([EveryVocaSortType].self)
            .asObservable()
    }

    public func getEveryVocabularies(sortType: String, page: Int) -> Observable<EveryVocaResponse> {
        return serviceManager.providerWithToken.rx
            .request(EveryVocabularyService.getEveryVocabularies(sortType: sortType, page: page))
            .map(EveryVocaResponse.self)
            .asObservable()
    }

    public func getEveryVocabulariesFolder(folderId: Int, page: Int) -> Observable<WordResponse> {
        return serviceManager.providerWithToken.rx
            .request(EveryVocabularyService.getEveryVocabulariesFolder(folderId: folderId, page: page))
            .map(WordResponse.self)
            .asObservable()
    }

    public func downloadFolder(downloadFolderId: Int, myFolderId: Int) -> Observable<Response> {
        return serviceManager.providerWithToken.rx
            .request(EveryVocabularyService.getEveryVocabulariesDownload(downloadFolderId: downloadFolderId, myFolderId: myFolderId))
            .asObservable()
    }
}

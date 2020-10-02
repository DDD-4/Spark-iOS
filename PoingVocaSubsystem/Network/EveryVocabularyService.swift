//
//  EveryVocabularyService.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Moya

enum EveryVocabularyService {
    case getEveryVocabulariesSortType
    case getEveryVocabularies(sortType: String, page: Int)
    case getEveryVocabulariesFolder(folderId: Int, page: Int)
    case getEveryVocabulariesDownload(downloadFolderId: Int, myFolderId: Int)

}

extension EveryVocabularyService: TargetType {
    var baseURL: URL {
        URL(string: ServerURL.base.rawValue)!
    }

    var path: String {
        switch self {
        case .getEveryVocabulariesSortType:
            return "/v1/every-vocabularies/sort-types"
        case .getEveryVocabularies:
            return "v1/every-vocabularies/"
        case .getEveryVocabulariesFolder(let folderId, _):
            return "v1/every-vocabularies/folders/\(folderId)"
        case .getEveryVocabulariesDownload(let downloadFolderId, _):
            return "v1/every-vocabularies/folders/\(downloadFolderId)"
        }
    }


    var method: Moya.Method {
        switch self {
        case .getEveryVocabulariesDownload:
            return .post
        default:
            return .get
        }
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        switch self {
        case .getEveryVocabularies(let sortType, let page):
            let params: [String : Any] = [
                "sortType" : sortType,
                "page" : page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getEveryVocabulariesFolder(_, let page):
            let params: [String: Any] = [
                "page" : page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getEveryVocabulariesDownload(_, let myFolderId):
            let param: [String : Any] = [
                "myFolderId": myFolderId
            ]
            return .requestParameters(parameters: param, encoding: JsonEncoding.default)
        case .getEveryVocabulariesSortType:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        nil
    }
}

class EveryVocabularyServiceManager: BaseManager<EveryVocabularyService> {}

//
//  EveryVocabularyService.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Moya

enum EveryVocabularyService {
    case getEveryVocabularies
    case getEveryVocabulariesFolder(folderId: Int)
    case getEveryVocabulariesDownload(downloadFolderId: Int, myFolderId: Int)

}

extension EveryVocabularyService: TargetType {
    var baseURL: URL {
        URL(string: ServerURL.base.rawValue)!
    }

    var path: String {
        switch self {
        case .getEveryVocabularies:
            return "v1/every-vocabularies"
        case .getEveryVocabulariesFolder(let folderId):
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
        case .getEveryVocabularies:
            return .requestPlain
        case .getEveryVocabulariesFolder:
            return .requestPlain
        case .getEveryVocabulariesDownload(_, let myFolderId):
            let param: [String : Any] = [
                "myFolderId": myFolderId,
                "vocabularyIds": []
            ]
            return .requestParameters(parameters: param, encoding: JsonEncoding.default)
        }
    }

    var headers: [String : String]? {
        nil
    }
}

class EveryVocabularyServiceManager: BaseManager<EveryVocabularyService> {}

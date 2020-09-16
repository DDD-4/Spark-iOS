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

}

extension EveryVocabularyService: TargetType {
    var baseURL: URL {
        URL(string: "http://poingpoing.cf/")!
    }

    var path: String {
        switch self {
        case .getEveryVocabularies:
            return "v1/every-vocabularies"
        case .getEveryVocabulariesFolder(let folderId):
            return "v1/every-vocabularies/folders/\(folderId)"
        }
    }

    var method: Moya.Method {
        .get
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
        }
    }

    var headers: [String : String]? {
        nil
    }
}

class EveryVocabularyServiceManager: BaseManager<EveryVocabularyService> {}

//
//  WordService.swift
//  PoingVocaSubsystem
//
//  Created by apple on 2020/09/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Moya

enum WordService {
    case postWord(
            english: String,
            folderId: Int,
            korean: String,
            photo: Data
         )
    case deleteWord(vocabularyId: Int)
    case updateWord(
            vocabularyId: Int,
            english: String,
            folderId: Int,
            korean: String,
            photo: Data
         )
}

extension WordService: TargetType {
    
    var baseURL: URL {
        URL(string: ServerURL.base.rawValue)!
    }
    
    var path: String {
        switch self {
        case .postWord(let english, let folderId, let korean, let photo):
            return "V1/vocabularies"
        case .deleteWord(let vocabularyId):
            return "V1/vocabularies\(vocabularyId)"
        case .updateWord(let vocabularyId):
            return "V1/vocabularies\(vocabularyId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postWord:
            return .post
        case .deleteWord:
            return .delete
        case .updateWord:
            return .patch
        }
    }
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .postWord(let english, let folderId, let korean, let photo):
            let params: [String: Any] = [
                "english": english,
                "folderId": folderId,
                "korean": korean,
                "photo": photo
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .deleteWord(let vocabularyId):
            return .requestParameters(parameters: ["vocabularyId": vocabularyId], encoding: JSONEncoding.default)
        case .updateWord(_, let english, let folderId, let korean, let photo):
            let params: [String: Any] = [
                "english": english,
                "folderId": folderId,
                "korean": korean,
                "photo": photo
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
}

class WordServiceManager: BaseManager<WordService> {}
 

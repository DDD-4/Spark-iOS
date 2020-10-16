//
//  WordService.swift
//  PoingVocaSubsystem
//
//  Created by apple on 2020/09/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Moya

enum WordService {
    case getWord(folderId: Int, page: Int = 0)
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

extension WordService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        .bearer
    }

    var baseURL: URL {
        URL(string: ServerURL.base.rawValue)!
    }
    
    var path: String {
        switch self {
        case .getWord:
            return "v1/vocabularies"
        case .postWord:
            return "v1/vocabularies"
        case .deleteWord(let vocabularyId):
            return "v1/vocabularies/\(vocabularyId)"
        case .updateWord(let vocabularyId, _, _, _, _):
            return "v1/vocabularies/\(vocabularyId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWord:
            return .get
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
        case .getWord(let folderId, let page):
            return .requestParameters(parameters: ["folderId": folderId, "page": page], encoding: URLEncoding.default)
        case .postWord(let english, let folderId, let korean, let photo):
            
            var formData = [MultipartFormData]()
            formData.append(MultipartFormData(provider: .data(photo), name: "photo", fileName: "\(english).jpg", mimeType: "image/jpg"))
            formData.append(MultipartFormData(provider: .data(english.data(using: .utf8)!), name: "english"))
            formData.append(MultipartFormData(provider: .data(korean.data(using: .utf8)!), name: "korean"))
            formData.append(MultipartFormData(provider: .data("\(folderId)".data(using: .utf8)!), name: "folderId"))
            return .uploadMultipart(formData)
            
        case .deleteWord(_):
            return .requestPlain
        case .updateWord(_, let english, let folderId, let korean, let photo):
            
            var formData = [MultipartFormData]()
            formData.append(MultipartFormData(provider: .data(photo), name: "photo", fileName: "\(english).jpg", mimeType: "image/jpg"))
            formData.append(MultipartFormData(provider: .data(english.data(using: .utf8)!), name: "english"))
            formData.append(MultipartFormData(provider: .data(korean.data(using: .utf8)!), name: "korean"))
            formData.append(MultipartFormData(provider: .data("\(folderId)".data(using: .utf8)!), name: "folderId"))
            return .uploadMultipart(formData)
            
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
}

class WordServiceManager: BaseManager<WordService> {}


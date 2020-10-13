//
//  FolderService.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/09/17.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Moya
import Alamofire

enum FolderService {
    case getMyFolder
    case addFolder(name: String, shareable: Bool = true)
    case deleteFolder(folderId: [Int])
    case editFolder(folderId: Int, name: String, shareable: Bool = true)
    case reorderFolder(folderIds: [Int])
}

extension FolderService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    var baseURL: URL {
        URL(string: ServerURL.base.rawValue)!
    }

    var path: String {
        switch self {
        case .editFolder(let folderId, _ , _):
            return "v1/folders/\(folderId)"
        default:
            return "v1/folders"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMyFolder:
            return .get
        case .addFolder:
            return .post
        case .deleteFolder:
            return .delete
        case .editFolder:
            return .patch
        case .reorderFolder:
            return .put
        }
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        switch self {
        case .getMyFolder:
            return .requestPlain
        case .addFolder(let name, let shareable):
            let params: [String : Any] = [
                "name": name,
                "shareable": shareable
            ]
            return .requestParameters(parameters: params, encoding: JsonEncoding.default)

        case .deleteFolder(let folderId):
            return .requestParameters(parameters: ["folderIds": folderId], encoding: JsonEncoding.default)
        case .editFolder(_, let name, let shareable ):
            let params: [String : Any] = [
                "name": name,
                "shareable": shareable
            ]
            return .requestParameters(parameters: params, encoding: JsonEncoding.default)
        case .reorderFolder(let folderIds):
            let params: [String : Any] = [
                "folderIds": folderIds
            ]
            return .requestParameters(parameters: params, encoding: JsonEncoding.default)
        }
    }

    var headers: [String : String]? {
        nil
    }
}

class FolderServiceManager: BaseManager<FolderService> {}


/// Json encoding을 위해서 아래의 인코딩을 사용할것
struct JsonEncoding: Moya.ParameterEncoding {

    public static var `default`: JsonEncoding { return JsonEncoding() }


    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var req = try urlRequest.asURLRequest()
        let json = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.httpBody = json
        return req
    }

}

//
//  UserService.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/10/10.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Moya

enum UserService {
    case getUserInfo
    case signup(credential: String, name: String)
    case deleteUser
    case editUser(name: String, photo: String)
    case login(credential: String)
    // waiting server api
//    case logout
}

extension UserService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .login, .signup:
            return nil
        default:
            return .bearer
        }
    }

    var baseURL: URL {
        URL(string: ServerURL.base.rawValue)!
    }

    var path: String {
        switch self {
        case .getUserInfo, .editUser, .deleteUser:
            return "/v1/users"
        case .login:
            return "/v1/users/login"
        case .signup:
            return "/v1/users/sign-up"
//        case .logout:
//            return "/v1/users/logout"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .signup, .login:
            return .post
        case .deleteUser:
            return .delete
        case .editUser:
            return .patch
//        case .logout:
//            <#code#>
        }
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        case .signup(let credential, let name):
            let param: [String : Any] = [
                "credential": credential,
                "name": name
            ]
            return .requestParameters(parameters: param, encoding: JsonEncoding.default)
        case .deleteUser:
            return .requestPlain
        case .editUser(let name, let photo):
            let param: [String : Any] = [
                "name": name,
                "photo": photo
            ]
            return .requestParameters(parameters: param, encoding: JsonEncoding.default)
        case .login(let credential):
            let param: [String : Any] = [
                "credential": credential
            ]
            return .requestParameters(parameters: param, encoding: JsonEncoding.default)
        }
    }

    var headers: [String : String]? {
        nil
    }
}

class UserServiceManager: BaseManager<UserService> {}


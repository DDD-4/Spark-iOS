//
//  UserController.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/10/10.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import RxSwift
import Moya

public class UserController {
    public static let shared = UserController()
    private let serviceManager = UserServiceManager()

    public func getUserInfo() -> Observable<UserInfo> {
        serviceManager.providerWithToken.rx
            .request(UserService.getUserInfo)
            .map(UserInfo.self)
            .asObservable()
    }

    public func editUser(name: String, photo: Data?) -> Observable<Response> {
        serviceManager.providerWithToken.rx
            .request(UserService.editUser(name: name, photo: photo))
            .asObservable()
    }

    public func signup(credential: String, name: String) -> Observable<Response> {
        serviceManager.provider.rx
            .request(UserService.signup(credential: credential, name: name))
            .asObservable()
    }

    public func deleteUser() -> Observable<Response> {
        serviceManager.providerWithToken.rx
            .request(UserService.deleteUser)
            .asObservable()
    }

//    public func editUserInfo(name: String, photo: Data) -> Observable<Response> {
//        serviceManager.provider.rx
//            .request(UserService.editUser(name: <#T##String#>, photo: <#T##String#>))
//    }

    public func login(credential: String) -> Observable<Response> {
        serviceManager.provider.rx
            .request(UserService.login(credential: credential))
            .asObservable()
    }
}

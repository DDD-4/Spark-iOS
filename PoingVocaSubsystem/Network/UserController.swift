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

    public func editUser(name: String, photo: String) -> Observable<Response> {
        serviceManager.providerWithToken.rx
            .request(UserService.editUser(name: name, photo: photo))
            .asObservable()
    }

    public func signin(credential: String, name: String, email: String) -> Observable<Response> {
        serviceManager.provider.rx
            .request(UserService.signin(credential: credential, name: name, email: email))
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

    public func login(credential: String, email: String) -> Observable<Response> {
        serviceManager.provider.rx
            .request(UserService.login(credential: credential, email: email))
            .asObservable()
    }
}

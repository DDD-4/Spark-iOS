//
//  UserInfo.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/10/10.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public struct UserInfo: Codable {
    let id: String
    let name: String
    let photoUrl: String
}


public class Token {
    public static let shared = Token()
    public var token: String?
}

public struct LoginResponse: Codable {
    public let token: String
}

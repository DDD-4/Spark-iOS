//
//  WordResponse.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public struct WordResponse: Codable {
    public let english: String
    public let id: Int
    public let korean: String
    public let photoUrl: String
}

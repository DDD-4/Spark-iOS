//
//  WordResponse.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public class WordResponse: Codable {
    public let content: [Word]
    public let hasNext: Bool
    public let totalCount: Int
}
public class Word: Codable {
    internal init(
        id: Int,
        korean: String,
        english: String,
        photoUrl: String?
    ) {
        self.english = english
        self.id = id
        self.korean = korean
        self.photoUrl = photoUrl
    }

    public var english: String
    public var id: Int
    public var korean: String
    public var photoUrl: String?
}

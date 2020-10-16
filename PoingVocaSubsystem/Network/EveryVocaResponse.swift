//
//  EveryVocaResponse.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public struct EveryVocaSortType: Codable {
    public let key: String
    public let value: String
}

public struct EveryVocaResponse: Codable {
    public let content: [EveryVocaContent]
    public let hasNext: Bool
    public let totalCount: Int
}

public struct EveryVocaContent: Codable {
    public let count: Int
    public let folderName: String
    public let photoUrl: String
    public let userName: String
    public let userPhotoUrl: String?
    public let folderId: Int
}

public struct Pageable: Codable {
    public let offset: Int
    public let pageNumber: Int
    public let pageSize: Int
    public let paged: Bool
    public let sort: Sort
    public let unpaged: Bool
}

public struct Sort: Codable {
    public let empty: Bool
    public let sorted: Bool
    public let unsorted: Bool
}

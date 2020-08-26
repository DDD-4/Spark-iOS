//
//  CardMatching.swift
//  CardMatching
//
//  Created by LEE HAEUN on 2020/07/19.
//

import UIKit

class CardMatching {
    enum ContentType {
        case image(_ image: UIImage)
        case text(_ text: String)
    }

    let color: UIColor
    let contentType: ContentType
    let uuid: UUID

    init(contentType: ContentType, uuid: UUID, color: UIColor) {
        self.contentType = contentType
        self.uuid = uuid
        self.color = color
    }
}

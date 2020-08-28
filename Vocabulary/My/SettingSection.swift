//
//  SettingSection.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/27.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

enum Section: Int, CaseIterable {
    case profile
    case options
}

enum RightType {
    case `switch`
    case arrow
}

struct Option {
    let title: String
    let rightType: RightType?
    let handler: (() -> Void)
}

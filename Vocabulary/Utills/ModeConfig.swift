//
//  ModeConfig.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/19.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

enum ModeType {
    case offline
    case online
}

class ModeConfig {
    static let shared = ModeConfig()

    var currentMode: ModeType = .offline {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.modeConfig, object: nil)
        }
    }
}

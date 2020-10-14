//
//  ModeConfig.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/19.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public enum ModeType {
    case offline
    case online
}

public class ModeConfig {
    public static let shared = ModeConfig()

    public var currentMode: ModeType = .online {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.modeConfig, object: nil)
        }
    }
}

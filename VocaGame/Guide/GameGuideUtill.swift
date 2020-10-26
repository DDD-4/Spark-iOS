//
//  GameGuideUtill.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/10/25.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public enum GameGuideUtill {
    static var isNeedGuide: Bool {
        return UserDefaults.standard.bool(forKey: "VocaGame.Guide.Flip")
    }

    static func didShowGuide() {
        UserDefaults.standard.set(true, forKey: "VocaGame.Guide.Flip")
    }

    public static func reset() {
        UserDefaults.standard.set(false, forKey: "VocaGame.Guide.Flip")
    }
}

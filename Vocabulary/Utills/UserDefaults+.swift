//
//  UserDefaults+.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/10/13.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

extension UserDefaults {
    func setUserLoginIdentifier(indentifier: String) {
        UserDefaults.standard.setValue(indentifier, forKey: "LoginIdentifier")
    }

    func getUserLoginIdentifier() -> String? {
        UserDefaults.standard.string(forKey: "LoginIdentifier")
    }
}

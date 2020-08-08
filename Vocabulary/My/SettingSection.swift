//
//  SettingSection.swift
//  Vocabulary
//
//  Created by apple on 2020/08/04.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {

    case Social
    case Communications
    
    var description: String {
        switch self {
        case .Social: return "Social"
        case .Communications: return "Communications"
        }
    }
}

enum SocialOptions: Int, CaseIterable, SectionType {
    case editProfile
    case logout
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .editProfile: return "Edit Profile"
        case .logout: return "Log Out"
        }
    }
}

enum CommunicationsOptions: Int, CaseIterable, SectionType {
    case email
    case Notifications
    
    var description: String {
        switch self {
        case .Notifications: return "Notifications"
        case .email: return "Email"
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .Notifications: return true
        case .email: return true
        }
    }
}

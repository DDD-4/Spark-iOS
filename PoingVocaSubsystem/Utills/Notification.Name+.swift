//
//  Notification.Name+.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/08/08.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let vocaDataChanged = Notification.Name("vocaDataChanged")
    static let folderUpdate = Notification.Name("FolderUpdate")
    static let wordUpdate = Notification.Name("WordUpdate")
    static let myFolder = Notification.Name("MyFolder")
}

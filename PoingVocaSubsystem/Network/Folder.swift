//
//  FolderResponse.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/09/17.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public class Folder: Codable {
    internal init(default: Bool, id: Int, name: String, shareable: Bool) {
        self.default = `default`
        self.id = id
        self.name = name
        self.shareable = shareable
        }

    public var `default`: Bool
    public var id: Int
    public var name: String
    public var shareable: Bool
}

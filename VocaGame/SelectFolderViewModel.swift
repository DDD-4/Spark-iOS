//
//  SelectFolderViewModel.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/09/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import PoingVocaSubsystem

protocol SelectFolderViewModelDelegate: class {

}

protocol SelectFolderViewModelType {
    var folderList: [Folder] { get }
}

class SelectFolderViewModel: SelectFolderViewModelType {
    var folderList: [Folder]

    init(_ folderList: [Folder]) {
        self.folderList = folderList
    }
}

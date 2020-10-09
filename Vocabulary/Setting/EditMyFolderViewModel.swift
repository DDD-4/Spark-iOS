//
//  EditMyFolderViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/08.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

protocol EditMyFolderViewModelInput {
    func fetchMyFolders()
    func changeVisibilityType(folder: Folder)
    func deleteFolders(folders: [Folder])
    func addDeleteFolder(currentSelectedFolder: Folder)
    var deleteSelectedFolders: BehaviorRelay<[Folder]> { get }
    func reorderFolders(sourceIndex: Int, destinationIndex: Int)
    func reorderFolders(folders: [Folder])
}

protocol EditMyFolderViewModelOutput {
    var myFolders: BehaviorRelay<[Folder]> { get }
}

protocol EditMyFolderViewModelType {
    var input: EditMyFolderViewModelInput { get }
    var output: EditMyFolderViewModelOutput { get }
}

class EditMyFolderViewModel: EditMyFolderViewModelType, EditMyFolderViewModelInput, EditMyFolderViewModelOutput {
    var myFolders = BehaviorRelay<[Folder]>(value: [])
    var deleteSelectedFolders = BehaviorRelay<[Folder]>(value: [])
    var input: EditMyFolderViewModelInput { return self }
    var output: EditMyFolderViewModelOutput { return self }

    init() {
    }

    func fetchMyFolders() {
        VocaManager.shared.fetch(identifier: nil) { [weak self] (groups) in
            guard let self = self else { return }
            guard let groups = groups else {
                self.myFolders.accept([])
                return
            }

            let filteredGroups = self.filteredGroup(groups: groups)
            self.myFolders.accept(filteredGroups)
        }
    }

    private func filteredGroup(groups: [FolderCoreData]) -> [FolderCoreData] {
        groups.filter({ (group) -> Bool in
            group.visibilityType != .default && group.visibilityType != .group
        })
    }

    func changeVisibilityType(folder: Folder) {
        if let currentFolder = folder as? FolderCoreData {
            let changedVisibilityType: VisibilityType = (currentFolder.visibilityType == .public) ? .private : .public
            currentFolder.visibilityType = changedVisibilityType
            VocaManager.shared.update(group: currentFolder)
        }
    }

    func deleteFolders(folders: [Folder]) {
        guard let folders = folders as? [FolderCoreData] else {
            return
        }
        for folder in folders {
            VocaManager.shared.delete(group: folder)
        }
    }

    func addDeleteFolder(currentSelectedFolder: Folder) {
        var selectedGroupIndex: Int?
        guard var tempDeleteSelectedGroup = deleteSelectedFolders.value as? [FolderCoreData],
              let folder = currentSelectedFolder as? FolderCoreData else {
            return
        }

        for index in 0..<tempDeleteSelectedGroup.count {
            if tempDeleteSelectedGroup[index].identifier == folder.identifier {
                selectedGroupIndex = index
                break
            }
        }
        guard let index = selectedGroupIndex else {
            tempDeleteSelectedGroup.append(folder)
            deleteSelectedFolders.accept(tempDeleteSelectedGroup)
            return
        }

        tempDeleteSelectedGroup.remove(at: index)
        deleteSelectedFolders.accept(tempDeleteSelectedGroup)
    }

    func reorderFolders(
        sourceIndex: Int,
        destinationIndex: Int
    ) {
        guard let myFolders = myFolders.value as? [FolderCoreData] else {
            return
        }

        let sourceFolder = myFolders[sourceIndex]
        let destinationFolder = myFolders[destinationIndex]


        let tempFolder = myFolders

        tempFolder[sourceIndex].order = destinationFolder.order
        tempFolder[destinationIndex].order = sourceFolder.order

        VocaManager.shared.update(group: tempFolder[sourceIndex]) {
            VocaManager.shared.update(group: tempFolder[destinationIndex]) {
                
            }
        }
    }

    func reorderFolders(folders: [Folder]) {
        // This function is only used in online
    }
}

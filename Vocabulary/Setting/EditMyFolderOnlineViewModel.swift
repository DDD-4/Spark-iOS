//
//  EditMyFolderOnlineViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/19.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PoingVocaSubsystem

class EditMyFolderOnlineViewModel: EditMyFolderViewModelType, EditMyFolderViewModelInput, EditMyFolderViewModelOutput {
    var deleteSelectedFolders = BehaviorRelay<[Folder]>(value: [])

    var myFolders = BehaviorRelay<[Folder]>(value: [])
    let disposeBag = DisposeBag()

    var input: EditMyFolderViewModelInput { return self }
    var output: EditMyFolderViewModelOutput { return self }


    init() {

    }

    func fetchMyFolders() {
        FolderController.shared.getMyFolder()
            .map({ (folders) -> [Folder] in
                FolderManager.shared.myFolders = folders
                return folders.filter { (folder) -> Bool in
                    folder.default == false
                }
            })
            .subscribe { [weak self] (folders) in
                self?.myFolders.accept(folders)
            }
            .disposed(by: disposeBag)
    }

    func changeVisibilityType(folder: Folder, completion: (() -> Void)?) {
        folder.shareable = folder.shareable ? false : true
        FolderController.shared.editFolder(
            folderId: folder.id,
            name: folder.name,
            shareable: folder.shareable
        )
        .subscribe { (response) in
            print(response)
            if response.element?.statusCode == 200 {
                // success
                completion?()
            }
            else {
                // error
            }
        }
        .disposed(by: disposeBag)
    }

    func deleteFolders(folders: [Folder], completion: (() -> Void)?) {
        let folderIds: [Int] = folders.map { (folder) -> Int in
            folder.id
        }
        FolderController.shared.deleteFolder(folderId: folderIds)
            .subscribe { (response) in
                if response.element?.statusCode == 200 {
                    // success
                    completion?()
                }
                else {
                    // error
                }
            }
            .disposed(by: disposeBag)
    }

    func addDeleteFolder(currentSelectedFolder: Folder) {
        var selectedGroupIndex: Int?
        var tempDeleteSelectedGroup = deleteSelectedFolders.value

        for index in 0..<tempDeleteSelectedGroup.count {
            if tempDeleteSelectedGroup[index].id == currentSelectedFolder.id {
                selectedGroupIndex = index
                break
            }
        }
        guard let index = selectedGroupIndex else {
            tempDeleteSelectedGroup.append(currentSelectedFolder)
            deleteSelectedFolders.accept(tempDeleteSelectedGroup)
            return
        }

        tempDeleteSelectedGroup.remove(at: index)
        deleteSelectedFolders.accept(tempDeleteSelectedGroup)
    }

    func reorderFolders(
        sourceIndex: Int,
        destinationIndex: Int,
        completion: @escaping (() -> Void)
    ) {
        // This function is only used in coredata
    }

    func reorderFolders(folders: [Folder]) {
        let folderIDs = folders.map { (folder) -> Int in
            folder.id
        }
        FolderController.shared.reorderFolder(folderIds: folderIDs)
            .subscribe { [weak self] (response) in
                if response.element?.statusCode == 200 {
                    // success
                    self?.fetchMyFolders()
                }
                else {
                    // error
                }
            }
            .disposed(by: disposeBag)
    }
}

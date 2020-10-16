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
            .subscribe(onNext: { [weak self] (folders) in
                self?.myFolders.accept(folders)
            }, onError: { [weak self] (error) in
                UIAlertController().presentShowAlert(
                    title: "네트워크 오류",
                    message: nil,
                    leftButtonTitle: "취소",
                    rightButtonTitle: "재시도"
                ) { [weak self] (index) in
                    guard index == 1 else { return }
                    self?.fetchMyFolders()
                }
            })
            .disposed(by: disposeBag)
    }

    func changeVisibilityType(folder: Folder) {
        LoadingView.show()

        folder.shareable = folder.shareable ? false : true
        FolderController.shared.editFolder(
            folderId: folder.id,
            name: folder.name,
            shareable: folder.shareable
        )
        .subscribe(onNext: { [weak self] (response) in
            LoadingView.hide()
            if response.statusCode == 200 {
                self?.fetchMyFolders()
            }
        }, onError: { (error) in
            LoadingView.hide()
        })
        .disposed(by: disposeBag)
    }

    func deleteFolders(folders: [Folder]) {
        let folderIds: [Int] = folders.map { (folder) -> Int in
            folder.id
        }
        LoadingView.show()

        FolderController.shared.deleteFolder(folderId: folderIds)
            .subscribe(onNext: { [weak self] (response) in
                LoadingView.hide()
                if response.statusCode == 200 {
                    self?.fetchMyFolders()
                }
            }, onError: { [weak self] (error) in
                LoadingView.hide()
                UIAlertController().presentShowAlert(
                    title: nil,
                    message: "네트워크 오류",
                    leftButtonTitle: "취소",
                    rightButtonTitle: "재시도"
                ) { [weak self] (index) in
                    guard index == 1 else { return }
                    self?.deleteFolders(folders: folders)
                }
            })
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
        destinationIndex: Int
    ) {
        // This function is only used in coredata
    }

    func reorderFolders(folders: [Folder]) {
        LoadingView.show()
        let folderIDs = folders.map { (folder) -> Int in
            folder.id
        }
        FolderController.shared.reorderFolder(folderIds: folderIDs)
            .subscribe(onNext: { [weak self] (response) in
                LoadingView.hide()
                if response.statusCode == 200 {
                    self?.fetchMyFolders()
                }
            }, onError: { [weak self] (erroe) in
                LoadingView.hide()
                UIAlertController().presentShowAlert(
                    title: nil,
                    message: "네트워크 오류",
                    leftButtonTitle: "취소",
                    rightButtonTitle: "재시도"
                ) { [weak self] (index) in
                    guard index == 1 else { return }
                    self?.reorderFolders(folders: folders)
                }
            })
            .disposed(by: disposeBag)
    }
}

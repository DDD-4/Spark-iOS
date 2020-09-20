//
//  MyFolderDetailOnlineViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/19.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PoingVocaSubsystem

protocol MyFolderDetailViewModelInput {
    func addFolder(
        name: String,
        isShareable: Bool,
        completeHandler: (() -> Void)?
    )

    func editFolder(
        folder: Folder,
        name: String,
        isShareable: Bool,
        completion:  @escaping (() -> Void)
    )

    var editFolder: BehaviorRelay<Folder?> { get }
}

protocol MyFolderDetailViewModelOutput {

}

protocol MyFolderDetailViewModelType {
    var input: MyFolderDetailViewModelInput { get }
    var output: MyFolderDetailViewModelOutput { get }
}

class MyFolderDetailOnlineViewModel: MyFolderDetailViewModelInput, MyFolderDetailViewModelOutput, MyFolderDetailViewModelType {
    var input: MyFolderDetailViewModelInput { return self }
    var output: MyFolderDetailViewModelOutput { return self }

    let disposeBag = DisposeBag()

    var editFolder: BehaviorRelay<Folder?>

    init(editFolder: Folder? = nil) {
        self.editFolder = BehaviorRelay(value: editFolder)
    }

    func addFolder(name: String, isShareable: Bool, completeHandler: (() -> Void)?) {
        FolderController.shared.addFolder(name: name, shareable: isShareable)
            .subscribe { (response) in
                if response.element?.statusCode == 200 {
                    // success
                    completeHandler?()
                }
                else {
                    // error
                }
            }
            .disposed(by: disposeBag)
    }

    func editFolder(folder: Folder, name: String, isShareable: Bool, completion: @escaping  (() -> Void)) {
        FolderController.shared.editFolder(
            folderId: folder.id,
            name: name,
            shareable: isShareable
        )
        .subscribe { (response) in
            if response.element?.statusCode == 200 {
                // success
                completion()
            }
            else {
                // error
            }
        }
        .disposed(by: disposeBag)
    }

}

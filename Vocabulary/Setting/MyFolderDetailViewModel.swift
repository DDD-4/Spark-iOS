//
//  MyFolderDetailViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/19.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PoingVocaSubsystem

class MyFolderDetailViewModel: MyFolderDetailViewModelInput, MyFolderDetailViewModelOutput, MyFolderDetailViewModelType {
    var input: MyFolderDetailViewModelInput { return self }
    var output: MyFolderDetailViewModelOutput { return self }
    
    let disposeBag = DisposeBag()

    var editFolder: BehaviorRelay<Folder?>

    init(editFolder: Folder? = nil) {
        self.editFolder = BehaviorRelay(value: editFolder)
    }

    func addFolder(name: String, isShareable: Bool, completeHandler: (() -> Void)?) {
        let folderOrder = VocaManager.shared.groups?.count ?? 0
        let visibilityType: VisibilityType = isShareable ? .public : .private

        let newFolder = FolderCoreData(
            name: name,
            visibilityType: visibilityType,
            identifier: UUID(),
            words: [],
            order: Int16(folderOrder)
        )

        VocaManager.shared.insert(group: newFolder) {
            completeHandler?()
        }
    }

    func editFolder(
        folder: Folder,
        name: String,
        isShareable: Bool,
        completion: @escaping (() -> Void)
    ) {
        guard let folder = folder as? FolderCoreData else {
            return
        }

        folder.name = name
        folder.visibilityType = isShareable ? .public : .private

        VocaManager.shared.update(
            group: folder
        ) {
            completion()
        }
    }
}

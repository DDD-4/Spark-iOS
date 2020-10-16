//
//  SelectOnlineViewModel.swift
//  Vocabulary
//
//  Created by apple on 2020/09/29.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PoingVocaSubsystem

class SelectOnlineViewModel:
    SelectViewModelInput,
    SelectViewModelOutput,
    SelectViewModelType {

    var myFolders = BehaviorRelay<[Folder]>(value: [])
    
    var input: SelectViewModelInput { return self }
    var output: SelectViewModelOutput { return self }
    let disposeBag = DisposeBag()
    
    init() {
        myFolders = BehaviorRelay(value: FolderManager.shared.myFolders)
    }
    func fetchMyFolders() {
        FolderController.shared.getMyFolder()
            .subscribe { [weak self] (folders) in
                
                guard let self = self,
                      let folders = folders.element else {
                    return
                }
                self.myFolders.accept(folders)
                FolderManager.shared.myFolders = folders
            }.disposed(by: disposeBag)
    }
    
    private func filteredGroup(groups: [FolderCoreData]) -> [FolderCoreData] {
        groups.filter({ (group) -> Bool in
            group.visibilityType != .default && group.visibilityType != .group
        })
    }
}

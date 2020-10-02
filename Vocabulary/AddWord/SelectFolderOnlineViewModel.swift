//
//  SelectFolderOnlineViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/26.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PoingVocaSubsystem

class SelectFolderOnlineViewModel: SelectViewModelType, SelectViewModelInput, SelectViewModelOutput {
    var input: SelectViewModelInput { return self }
    var output: SelectViewModelOutput { return self }

    var groups: BehaviorRelay<[Folder]>

    var disposebag = DisposeBag()

    init() {
        groups = BehaviorRelay(value: FolderManager.shared.myFolders)
    }
    func fetchGroups() {
        FolderController.shared.getMyFolder()
            .subscribe { [weak self] (folders) in
                guard let self = self,
                      let folders = folders.element else {
                    return
                }
                print(folders)
                self.groups.accept(folders)
            }.disposed(by: disposebag)
    }


}

//
//  EditMyVocaGroupViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/08.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

protocol SelectViewModelOutput {
    var myFolders: BehaviorRelay<[Folder]> { get}
}

protocol SelectViewModelInput {
    func fetchMyFolders()
}

protocol SelectViewModelType {
    var input: SelectViewModelInput { get }
    var output: SelectViewModelOutput { get }
}

class SelectViewModel: SelectViewModelType, SelectViewModelInput, SelectViewModelOutput {
    
    let disposeBag = DisposeBag()
    var input: SelectViewModelInput { return self }
    
    var output: SelectViewModelOutput { return self }
    
    var myFolders: BehaviorRelay<[Folder]>

    init() {
        myFolders = BehaviorRelay<[Folder]>(value: [])
    }

    @objc func fetchMyFolders() {
        VocaManager.shared.fetch(identifier: nil) { [weak self] (groups) in
            guard let self = self else { return }
            guard let groups = groups, groups.isEmpty == false else {
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
}

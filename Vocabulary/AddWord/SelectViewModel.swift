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
    var groups: BehaviorRelay<[Group]> { get }
    var words: BehaviorRelay<[Word]> { get }
}

protocol SelectViewModelInput {
    func fetchGroups()
    var selectedGroupIndex: BehaviorRelay<Int?> { get }
    var selectedGroup: BehaviorRelay<Group?> { get }
}

protocol SelectViewModelType {
    var input: SelectViewModelInput { get }
    var output: SelectViewModelOutput { get }
}

class SelectViewModel: SelectViewModelType, SelectViewModelInput, SelectViewModelOutput {
    let disposeBag = DisposeBag()
    var input: SelectViewModelInput { return self }
    
    var output: SelectViewModelOutput { return self }
    
    var selectedGroupIndex: BehaviorRelay<Int?>
    
    var selectedGroup: BehaviorRelay<Group?>
    
    var words: BehaviorRelay<[Word]>
    
    var groups = BehaviorRelay<[Group]>(value: [])

    init() {
        words = BehaviorRelay<[Word]>(value: [])
        selectedGroup = BehaviorRelay<Group?>(value: nil)
        groups = BehaviorRelay<[Group]>(value: [])
        selectedGroupIndex = BehaviorRelay<Int?>(value: nil)

        selectedGroup.map { (group) -> [Word] in
            group?.words ?? []
        }
        .bind(to: words)
        .disposed(by: disposeBag)
    }

    func fetchGroups() {
       VocaManager.shared.fetch(identifier: nil) { [weak self] (groups) in
            guard let self = self else { return }
            guard let groups = groups, groups.isEmpty == false else {
                self.groups.accept([])
                return
            }
            self.groups.accept(groups)

            let currentSelectedGroup = groups.filter { (group) -> Bool in
                group.identifier == self.selectedGroup.value?.identifier
            }

            if currentSelectedGroup.isEmpty == false {
                self.selectedGroup.accept(currentSelectedGroup.first)
            } else {
                self.selectedGroup.accept(groups.first!)
            }
        }
    }
}

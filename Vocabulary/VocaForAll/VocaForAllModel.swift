//
//  VocaForAllModel.swift
//  Vocabulary
//
//  Created by apple on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

protocol VocaForAllViewModelOutput {
    var groups: BehaviorRelay<[Group]> { get }
    var words: BehaviorRelay<[Word]> { get }
}

protocol VocaForAllViewModelInput {
    func fetchGroups()
    var selectedGroupIndex: BehaviorRelay<Int?> { get }
    var selectedGroup: BehaviorRelay<Group?> { get }
}

protocol VocaForAllViewModelType {
    var input: VocaForAllViewModelInput { get }
    var output: VocaForAllViewModelOutput { get }
}

class VocaForAllViewModel: VocaForAllViewModelInput, VocaForAllViewModelOutput, VocaForAllViewModelType {
    let disposeBag = DisposeBag()
    
    var input: VocaForAllViewModelInput { return self }
    var output: VocaForAllViewModelOutput { return self }
    
    var words: BehaviorRelay<[Word]>
    
    var selectedGroup: BehaviorRelay<Group?>
    
    var groups = BehaviorRelay<[Group]>(value: [])
    
    var selectedGroupIndex: BehaviorRelay<Int?>
    
    init( ) {
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

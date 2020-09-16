//
//  WordViewModel.swift
//  Vocabulary
//
//  Created by apple on 2020/08/03.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

enum VocaOrderType: Int, CaseIterable {
    case recent
    case popular

    var description: String {
        switch self {
        case .popular:
            return "인기순"
        case .recent:
            return "최신순"
        }
    }
}

protocol WordViewModelOutput {
    var groups: BehaviorRelay<[Group]> { get }
    var words: BehaviorRelay<[Word]> { get }
}

protocol WordViewModelInput {
    func fetchGroups()
    var selectedGroup: BehaviorRelay<Group?> { get }
}

protocol WordViewModelType {
    var input: WordViewModelInput { get }
    var output: WordViewModelOutput { get }
}

class WordViewModel: WordViewModelInput, WordViewModelOutput, WordViewModelType {
    var groups: BehaviorRelay<[Group]>
    
    var selectedGroup: BehaviorRelay<Group?>
    
    let disposeBag = DisposeBag()

    var words: BehaviorRelay<[Word]>

    var input: WordViewModelInput { return self }
    var output: WordViewModelOutput { return self }

    init(group: Group?) {
        if let groupData = group{
            self.selectedGroup = BehaviorRelay(value: groupData)
            self.words = BehaviorRelay(value: groupData.words)
            self.groups = BehaviorRelay(value: [groupData])
        } else {
            words = BehaviorRelay<[Word]>(value: [])
            groups = BehaviorRelay<[Group]>(value: [])
            selectedGroup = BehaviorRelay<Group?>(value: nil)
        }
    }
    func fetchGroups() {
        VocaManager.shared.fetch(identifier: nil) { [weak self] (groups) in
            guard let self = self else { return }
            guard let groups = groups, groups.isEmpty == false else {
                self.groups.accept([])
                return
            }
            self.groups.accept(groups)
        }
    }
}

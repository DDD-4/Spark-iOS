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
    var groups: BehaviorRelay<[Group]> { get}
}

protocol SelectViewModelInput {
    func fetchGroups()
}

protocol SelectViewModelType {
    var input: SelectViewModelInput { get }
    var output: SelectViewModelOutput { get }
}

class SelectViewModel: SelectViewModelType, SelectViewModelInput, SelectViewModelOutput {
    let disposeBag = DisposeBag()
    var input: SelectViewModelInput { return self }
    
    var output: SelectViewModelOutput { return self }
    
    var groups: BehaviorRelay<[Group]>

    init() {
        groups = BehaviorRelay(value: VocaManager.shared.groups ?? [])
    }

    @objc func fetchGroups() {
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

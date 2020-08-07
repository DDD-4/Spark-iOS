//
//  MyVocaViewModel.swift
//  Vocabulary
//
//  Created by user on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

protocol MyVocaViewModelOutput {
    var groups: BehaviorRelay<[Group]> { get }
    var words: BehaviorRelay<[Word]> { get }
}

protocol MyVocaViewModelInput {
    func fetchGroups()
    var selectedGroupIndex: BehaviorRelay<Int?> { get }
    var selectedGroup: BehaviorRelay<Group?> { get }
}

protocol MyVocaViewModelType {
    var input: MyVocaViewModelInput { get }
    var output: MyVocaViewModelOutput { get }
}

class MyVocaViewModel: MyVocaViewModelInput, MyVocaViewModelOutput, MyVocaViewModelType {
    let disposeBag = DisposeBag()

    var words: BehaviorRelay<[Word]>

    var selectedGroup: BehaviorRelay<Group?>

    var groups: BehaviorRelay<[Group]>

    var selectedGroupIndex: BehaviorRelay<Int?>

    var input: MyVocaViewModelInput { return self }
    var output: MyVocaViewModelOutput { return self }


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
            self.selectedGroup.accept(groups.first!)
        }
    }
}

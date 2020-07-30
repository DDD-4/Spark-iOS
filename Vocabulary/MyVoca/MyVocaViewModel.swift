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
import Voca

protocol MyVocaViewModelOutput {
    var groups: BehaviorRelay<[Group]> { get }
}

protocol MyVocaViewModelInput {
    func fetchGroups()
    var selectedGroupIndex: BehaviorRelay<Int?> { get }
}

protocol MyVocaViewModelType {
    var input: MyVocaViewModelInput { get }
    var output: MyVocaViewModelOutput { get }
}

class MyVocaViewModel: MyVocaViewModelInput, MyVocaViewModelOutput, MyVocaViewModelType {
    var groups: BehaviorRelay<[Group]>

    var selectedGroupIndex: BehaviorRelay<Int?>

    var input: MyVocaViewModelInput { return self }
    var output: MyVocaViewModelOutput { return self }


    init() {
        groups = BehaviorRelay<[Group]>(value: [])
        selectedGroupIndex = BehaviorRelay<Int?>(value: nil)
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

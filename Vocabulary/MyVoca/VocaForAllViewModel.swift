//
//  VocaForAllViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PoingVocaSubsystem

enum VocaForAllOrderType: Int, CaseIterable {
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

protocol VocaForAllViewModelInput {
    func fetchVocaForAllData()
    var orderType: BehaviorRelay<VocaForAllOrderType> { get }
}

protocol VocaForAllViewModelOutput {
    var vocaForAllList: BehaviorRelay<[EveryVocaContent]> { get }
}

protocol VocaForAllViewModelType {
    var inputs: VocaForAllViewModelInput { get }
    var outputs: VocaForAllViewModelOutput { get }
}

class VocaForAllViewModel: VocaForAllViewModelType, VocaForAllViewModelInput, VocaForAllViewModelOutput {
    
    var inputs: VocaForAllViewModelInput { return self }
    var outputs: VocaForAllViewModelOutput { return self }

    // Input
    var orderType: BehaviorRelay<VocaForAllOrderType>
    // Output
    var vocaForAllList: BehaviorRelay<[EveryVocaContent]>

    var disposeBag = DisposeBag()
    
    init() {
        orderType = BehaviorRelay<VocaForAllOrderType>(value: .recent)
        vocaForAllList = BehaviorRelay<[EveryVocaContent]>(value: [])
    }

    func fetchVocaForAllData() {
        EveryVocabularyController.shared.getEveryVocabularies()
            .bind { [weak self] (response) in
                guard let self = self else { return }
                self.vocaForAllList.accept(response.content)
            }
            .disposed(by: disposeBag)
    }
}

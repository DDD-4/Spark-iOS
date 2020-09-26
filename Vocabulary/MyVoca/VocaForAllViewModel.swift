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
    case latest
    case popular

    var description: String {
        switch self {
        case .popular:
            return "인기순"
        case .latest:
            return "최신순"
        }
    }
}

protocol VocaForAllViewModelInput {
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
        orderType = BehaviorRelay<VocaForAllOrderType>(value: .latest)
        vocaForAllList = BehaviorRelay<[EveryVocaContent]>(value: [])

        orderType.bind{ [weak self] (type) in
            guard let self = self else { return }
            switch type {
            // TODO: Apply sort type
            case .popular, .latest:
                self.fetchVocaForAllData()
            }
        }.disposed(by: disposeBag)

    }

    private func fetchVocaForAllData() {
        let orderType: EveryVocabularySortType = (self.orderType.value == .popular)
            ? .popular
            : .latest

        EveryVocabularyController.shared.getEveryVocabularies(sortType: orderType)
            .subscribe { [weak self] (response) in
                guard let self = self, let element = response.element else { return }
                self.vocaForAllList.accept(element.content)
            }
            .disposed(by: disposeBag)
    }
}

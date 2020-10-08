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

protocol VocaForAllViewModelInput {
    var orderType: BehaviorRelay<EveryVocaSortType?> { get }
    var currentPage: BehaviorRelay<Int> { get }
    func fetchEveryVocaSortTypes()
}

protocol VocaForAllViewModelOutput {
    var vocaForAllList: BehaviorRelay<[EveryVocaContent]> { get }
    var everyVocaSortTypes: BehaviorRelay<[EveryVocaSortType]> { get }
    func hasMoreEveryVocaContent() -> Bool
    var vocaShouldShowLoadingCell: BehaviorRelay<Bool> { get }
}

protocol VocaForAllViewModelType {
    var inputs: VocaForAllViewModelInput { get }
    var outputs: VocaForAllViewModelOutput { get }
}

class VocaForAllViewModel: VocaForAllViewModelType, VocaForAllViewModelInput, VocaForAllViewModelOutput {
    var inputs: VocaForAllViewModelInput { return self }
    var outputs: VocaForAllViewModelOutput { return self }

    // Input
    var orderType: BehaviorRelay<EveryVocaSortType?>
    // Output
    var vocaForAllList: BehaviorRelay<[EveryVocaContent]>
    var vocaHasMore: BehaviorRelay<Bool>
    var vocaShouldShowLoadingCell: BehaviorRelay<Bool>

    var everyVocaSortTypes: BehaviorRelay<[EveryVocaSortType]>

    var currentPage: BehaviorRelay<Int>

    var disposeBag = DisposeBag()

    init() {
        orderType = BehaviorRelay<EveryVocaSortType?>(value: nil)
        vocaForAllList = BehaviorRelay<[EveryVocaContent]>(value: [])
        everyVocaSortTypes = BehaviorRelay<[EveryVocaSortType]>(value: [])
        currentPage = BehaviorRelay<Int>(value: 0)
        vocaHasMore = BehaviorRelay<Bool>(value: false)
        vocaShouldShowLoadingCell = BehaviorRelay<Bool>(value: false)

        orderType
            .bind { [weak self] _ in
                self?.currentPage.accept(0)
                self?.vocaHasMore.accept(false)
            }.disposed(by: disposeBag)

        currentPage
            .bind { [weak self] page in
                guard let self = self ,
                      let type = self.orderType.value else {
                    return
                }
                self.fetchVocaForAllData(sortTypeKey: type.key, page: page)
        }.disposed(by: disposeBag)

    }

    func hasMoreEveryVocaContent() -> Bool {
        vocaHasMore.value && vocaShouldShowLoadingCell.value == false
    }

    func fetchEveryVocaSortTypes() {
        EveryVocabularyController.shared.getEveryVocabulariesSortType()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (response) in
                guard let element = response.element else { return }
                self?.orderType.accept(element.first)
                self?.everyVocaSortTypes.accept(element)
            }
            .disposed(by: disposeBag)
    }

    func fetchVocaForAllData(sortTypeKey: String, page: Int) {
        vocaShouldShowLoadingCell.accept(true)
        EveryVocabularyController.shared.getEveryVocabularies(sortType: sortTypeKey, page: page)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (response) in
                self?.vocaShouldShowLoadingCell.accept(false)
                guard let self = self, let element = response.element else { return }
                if page == 0 {
                    self.vocaForAllList.accept(element.content)
                } else {
                    self.vocaForAllList.accept(self.vocaForAllList.value + element.content)
                }
                self.vocaHasMore.accept(element.hasNext)
            }
            .disposed(by: disposeBag)
    }
}

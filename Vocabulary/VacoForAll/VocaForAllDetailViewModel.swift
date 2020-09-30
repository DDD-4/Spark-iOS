//
//  VocaForAllDetailViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/19.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PoingVocaSubsystem

protocol VocaForAllDetailOutput {
    var vocaContent: BehaviorRelay<[Word]> { get }
    func hasMoreEveryVocaContent() -> Bool
    var vocaShouldShowLoadingCell: BehaviorRelay<Bool> { get }
}

protocol VocaForAllDetailInput {
    var currentPage: BehaviorRelay<Int?> { get }
    var content: BehaviorRelay<EveryVocaContent> { get }
    func downloadWord(myFolderId: Int, completion: @escaping (() -> Void))
}

protocol VocaForAllDetailType {
    var input: VocaForAllDetailInput { get }
    var output: VocaForAllDetailOutput { get }
}

class VocaForAllDetailViewModel: VocaForAllDetailOutput, VocaForAllDetailInput, VocaForAllDetailType {
    let disposeBag = DisposeBag()

    var content: BehaviorRelay<EveryVocaContent>
    var vocaContent: BehaviorRelay<[Word]>
    var vocaHasMore: BehaviorRelay<Bool>
    var vocaShouldShowLoadingCell: BehaviorRelay<Bool>
    var currentPage: BehaviorRelay<Int?>

    var input: VocaForAllDetailInput { return self }
    var output: VocaForAllDetailOutput { return self }

    init(content: EveryVocaContent) {
        self.content = BehaviorRelay(value: content)
        vocaContent = BehaviorRelay(value: [])
        vocaHasMore = BehaviorRelay(value: false)
        currentPage = BehaviorRelay(value: nil)
        vocaShouldShowLoadingCell = BehaviorRelay<Bool>(value: false)

        currentPage
            .bind { [weak self] page in
                guard let page = page else { return }
                self?.fetchFolder(page: page)
            }.disposed(by: disposeBag)
    }

    func hasMoreEveryVocaContent() -> Bool {
        vocaHasMore.value && vocaShouldShowLoadingCell.value == false
    }

    func fetchFolder(page: Int) {
        vocaShouldShowLoadingCell.accept(true)
        EveryVocabularyController.shared.getEveryVocabulariesFolder(folderId: content.value.folderId, page: page)
            .subscribe({ [weak self] (response) in
                self?.vocaShouldShowLoadingCell.accept(false)
                guard let self = self, let element = response.element else { return }
                self.vocaContent.accept(self.vocaContent.value + element.content)
                self.vocaHasMore.accept(element.hasNext)
            })
            .disposed(by: disposeBag)
    }

    func downloadWord(myFolderId: Int, completion: @escaping (() -> Void)) {
        EveryVocabularyController.shared.downloadFolder(
            downloadFolderId: content.value.folderId,
            myFolderId: myFolderId
        )
        .subscribe { (response) in
            print(response)
            if response.element?.statusCode == 200 {
                // success
                completion()
            }
            else {
                // error
            }
        }
        .disposed(by: disposeBag)
    }

}

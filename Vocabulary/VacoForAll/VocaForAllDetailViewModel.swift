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
}

protocol VocaForAllDetailInput {
    func fetchFolder()
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

    var input: VocaForAllDetailInput { return self }
    var output: VocaForAllDetailOutput { return self }

    init(content: EveryVocaContent) {
        self.content = BehaviorRelay(value: content)
        self.vocaContent = BehaviorRelay(value: [])
    }

    func fetchFolder() {
        EveryVocabularyController.shared.getEveryVocabulariesFolder(folderId: content.value.folderId)
            .bind{ [weak self] (response) in
                print(response)
                guard let self = self else { return }
                self.vocaContent.accept(response)
            }
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

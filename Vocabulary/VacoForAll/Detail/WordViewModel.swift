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

protocol WordViewModelOutput {
    var vocaContent: BehaviorRelay<[WordResponse]> { get }
}

protocol WordViewModelInput {
    func fetchFolder()
    var content: BehaviorRelay<EveryVocaContent> { get }
}

protocol WordViewModelType {
    var input: WordViewModelInput { get }
    var output: WordViewModelOutput { get }
}

class WordViewModel: WordViewModelInput, WordViewModelOutput, WordViewModelType {
    let disposeBag = DisposeBag()

    // Input
    var content: BehaviorRelay<EveryVocaContent>
    // Output
    var vocaContent: BehaviorRelay<[WordResponse]>

    var input: WordViewModelInput { return self }
    var output: WordViewModelOutput { return self }

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
}

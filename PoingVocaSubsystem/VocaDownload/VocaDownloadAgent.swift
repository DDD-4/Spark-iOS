//
//  VocaDownloadAgent.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/08/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class VocaDownloadAgent {
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    let dummyData: [Word]
    public init(data: [Word]) {
        dummyData = data
    }

    public func download(completion: @escaping ([WordCoreData]) -> Void) {
        var downloadedWord: [WordCoreData] = []
        var order: Int = 0
        for data in dummyData {
            let operation = VocaDownloadOperation(session: URLSession.shared, download: data) { (word, error) in
                NSLog("VocaDownloadOperation \(word?.english) download finished")
                guard let word = word else { return }
                word.order = Int16(order)
                downloadedWord.append(word)

                order += 1
            }
            operationQueue.addOperation(operation)
        }

        operationQueue.addBarrierBlock {
            DispatchQueue.main.async {
                NSLog("VocaDownloadOperation All Done!!!")
                completion(downloadedWord)
            }
        }
    }
}

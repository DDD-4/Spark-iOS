//
//  VocaDownloadOperation.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/08/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

class VocaDownloadOperation: Operation {

    private var task : URLSessionDownloadTask!

    enum OperationState : Int {
        case ready
        case executing
        case finished
    }

    // default state is ready (when the operation is created)
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }

        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }

    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }

    init(session: URLSession, download: WordDownload, completionHandler: ((Word?, Error?) -> Void)?) {
        super.init()

        // use weak self to prevent retain cycle
        task = session.downloadTask(with: URL(string: download.imageURL)!, completionHandler: { [weak self] (localURL, response, error) in

            /*
             if there is a custom completionHandler defined,
             pass the result gotten in downloadTask's completionHandler to the
             custom completionHandler
             */
            if let completionHandler = completionHandler {
                // localURL is the temporary URL the downloaded file is located

                let data = try! Data(contentsOf: localURL!)

                completionHandler(Word(korean: download.korean, english: download.english, image: data, identifier: nil, order: 0), nil)
            }

            /*
             set the operation state to finished once
             the download task is completed or have error
             */
            self?.state = .finished
        })
    }

    override func start() {
      /*
      if the operation or queue got cancelled even
      before the operation has started, set the
      operation state to finished and return
      */
      if(self.isCancelled) {
          state = .finished
          return
      }

      // set the state to executing
      state = .executing

      print("VocaDownloadOperation downloading \(self.task.originalRequest?.url?.absoluteString)")

      // start the downloading
      self.task.resume()
  }

  override func cancel() {
      super.cancel()

      // cancel the downloading
      self.task.cancel()
  }
}

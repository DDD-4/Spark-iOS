//
//  DummyData.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/08/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public struct WordDownload {
    public let korean: String
    public let english: String
    public let imageURL: String
}

public struct VocaForAll {
    public let title: String
    public let words: [WordDownload]
}

public class DummyData {
    public static let vocaForAll: [VocaForAll] = [
        VocaForAll(title: "Dummy", words: DummyData.vocaDownload),
        VocaForAll(title: "Dummy", words: DummyData.vocaDownload),
        VocaForAll(title: "Dummy", words: DummyData.vocaDownload)
    ]
    public static let vocaDownload: [WordDownload] = [
        WordDownload(korean: "캔디", english: "Candy", imageURL: "https://s7.orientaltrading.com/is/image/OrientalTrading/VIEWER_ZOOM/mixed-candy-assortment~k1958"),
        WordDownload(korean: "바나나", english: "Banana", imageURL: "https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg"),
        WordDownload(korean: "사과", english: "Apple", imageURL: "https://pbs.twimg.com/profile_images/1283958620359516160/p7zz5dxZ.jpg"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80"),
        WordDownload(korean: "한글", english: "english", imageURL: "https://images.unsplash.com/photo-1594476664296-8c552053aef3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1600&q=80")
    ]
}

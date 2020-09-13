//
//  PoingVocaSubsystemTests.swift
//  PoingVocaSubsystemTests
//
//  Created by LEE HAEUN on 2020/08/06.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import XCTest
@testable import PoingVocaSubsystem

/*
NOTICE 👼🏻
VocaManager's Unit test

기본적으로 VocaManager 가 context 를 비동기 방식으로 사용하도록 함 (perform으로)
Unit test에서 coredata를 비동기로 동작하면 테스트를 할 수 없음
그래서 performBackgroundTask에 perform 을 performAndWaitd으로 변경해서 실행

*/

class PoingVocaSubsystemTests: XCTestCase {

    let dummyWords = [
        Word(korean: "한글1", english: "eng1", image: UIImage().pngData(), identifier: UUID(), order: Int16(0)),
        Word(korean: "한글2", english: "eng1", image: UIImage().pngData(), identifier: UUID(), order: Int16(1)),
        Word(korean: "한글3", english: "eng1", image: UIImage().pngData(), identifier: UUID(), order: Int16(2)),
        Word(korean: "한글4", english: "eng1", image: UIImage().pngData(), identifier: UUID(), order: Int16(3)),
        Word(korean: "한글5", english: "eng1", image: UIImage().pngData(), identifier: UUID(), order: Int16(4)),
        Word(korean: "한글6", english: "eng1", image: UIImage().pngData(), identifier: UUID(), order: Int16(5)),
    ]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        VocaCoreDataManager.shared.reset()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_deleteAllGroup() {
        VocaManager.shared.fetch(identifier: nil) { (groups) in
            guard let groups = groups else { return }

            for group in groups {
                VocaManager.shared.delete(group: group)
            }
        }
    }

    func test_initGroup() {
        VocaCoreDataManager.shared.reset()

        VocaManager.shared.fetch(identifier: nil) { (managedGroups) in
            guard let managedGroups = managedGroups else {
                return
            }
            XCTAssertTrue(managedGroups.count == 1)
        }
    }

    func test_addDummyInDefault() {

        let exp = expectation(description: "callback")

        VocaManager.shared.fetch(visibilityType: .default) { (group) in
            guard let group = group, group.isEmpty == false, var firstGroup = group.first else {
                exp.fulfill()
                return
            }

            firstGroup.words = self.dummyWords
            VocaManager.shared.update(group: firstGroup) {
                VocaManager.shared.fetch(visibilityType: .default) { (managedGroups) in
                    guard let managedGroups = managedGroups else {
                        exp.fulfill()
                        return
                    }
                    XCTAssertEqual(managedGroups.first?.words.count, self.dummyWords.count)
                    exp.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_add() {
        let count = VocaManager.shared.groups?.count ?? 0

        let newGroup = Group(
            title: "1",
            visibilityType: .public,
            identifier: UUID(),
            words: dummyWords,
            order: Int16(count)
        )

        VocaManager.shared.insert(group: newGroup)

        VocaManager.shared.fetch(identifier: newGroup.identifier) { (managedGroups) in
            guard let managedGroups = managedGroups else {
                return
            }
            XCTAssertTrue(managedGroups.count == 1)
        }
    }

    func test_delete_words() {
        let count = VocaManager.shared.groups?.count ?? 0

        let newGroup = Group(
            title: "Unit Test Dummy",
            visibilityType: .public,
            identifier: UUID(),
            words: [
                Word(korean: "더미1", english: "더미1", image: nil, identifier: UUID(), order: 0),
                Word(korean: "더미2", english: "더미2", image: nil, identifier: UUID(), order: 1)
            ],
            order: Int16(count)
        )

        VocaManager.shared.insert(group: newGroup)

        VocaManager.shared.fetch(identifier: newGroup.identifier) { (managedGroups) in
            guard let managedGroups = managedGroups else {
                fatalError()
            }
            XCTAssertTrue(managedGroups.count == 1)
        }

        VocaManager.shared.update(
            group: newGroup,
            deleteWords: [newGroup.words.first!]
        ) {
            VocaManager.shared.fetch(identifier: newGroup.identifier) { (managedGroups) in
                guard let managedGroups = managedGroups else {
                    fatalError()
                }
                XCTAssertTrue(managedGroups.first!.words.count == 1)
            }
        }

    }

    func test_delete() {
        let count = VocaManager.shared.groups?.count ?? 0

        let newGroup = Group(
            title: "1",
            visibilityType: .public,
            identifier: UUID(),
            words: [],
            order: Int16(count)
        )
        VocaManager.shared.insert(group: newGroup)

        VocaManager.shared.fetch(identifier: newGroup.identifier) { (managedGroups) in
            guard let managedGroups = managedGroups else {
                fatalError()
            }
            XCTAssertTrue(managedGroups.count == 1)
        }

        VocaManager.shared.delete(group: newGroup)

        VocaManager.shared.fetch(identifier: newGroup.identifier) { (managedGroups) in
            guard let managedGroups = managedGroups else {
                return
            }
            XCTAssertTrue(managedGroups.count == 0)
        }

    }

    func test_update() {
        let count = VocaManager.shared.groups?.count ?? 0

        var newGroup = Group(
            title: "1",
            visibilityType: .public,
            identifier: UUID(),
            words: [],
            order: Int16(count)
        )
        VocaManager.shared.insert(group: newGroup)

        VocaManager.shared.fetch(identifier: newGroup.identifier) { (managedGroups) in
            guard let managedGroups = managedGroups else {
                fatalError()
            }
            XCTAssertTrue(managedGroups.count == 1)
        }

        newGroup.title = "2"

        VocaManager.shared.update(group: newGroup)

        VocaManager.shared.fetch(identifier: newGroup.identifier) { (managedGroups) in
            guard let managedGroups = managedGroups else {
                fatalError()
            }
            XCTAssertTrue(managedGroups.count == 1 && managedGroups.first?.title == newGroup.title)
        }
    }
}

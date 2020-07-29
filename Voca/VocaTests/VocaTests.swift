//
//  VocaTests.swift
//  VocaTests
//
//  Created by LEE HAEUN on 2020/07/28.
//  Copyright © 2020 Spark. All rights reserved.
//

import XCTest
@testable import Voca

/*
 NOTICE 👼🏻
 VocaManager's Unit test

 기본적으로 VocaManager 가 context 를 비동기 방식으로 사용하도록 함 (perform으로)
 Unit test에서 coredata를 비동기로 동작하면 테스트를 할 수 없음
 그래서 performBackgroundTask에 perform 을 performAndWaitd으로 변경해서 실행

 */
class VocaTests: XCTestCase {

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

    func test_add() {
        let newGroup = Group(
            title: "1",
            visibilityType: .public,
            identifier: UUID()
        )
        VocaManager.shared.insert(group: newGroup)

        VocaManager.shared.fetch(identifier: newGroup.identifier) { (managedGroups) in
            guard let managedGroups = managedGroups else {
                return
            }
            XCTAssertTrue(managedGroups.count == 1)
        }
    }

    func test_delete() {
        let newGroup = Group(
            title: "1",
            visibilityType: .public,
            identifier: UUID()
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
        var newGroup = Group(
            title: "1",
            visibilityType: .public,
            identifier: UUID()
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

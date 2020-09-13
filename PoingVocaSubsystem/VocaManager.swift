//
//  VocaManager.swift
//  Voca
//
//  Created by LEE HAEUN on 2020/07/28.
//  Copyright © 2020 Spark. All rights reserved.
//

import Foundation

// lightweight fetch, update, add, delete of Voca data Model
// VocaCoreDataManager should be internal scope
// if app wants to use voca data then use this VocaManager class 👀

public class VocaManager {
    public static let shared = VocaManager()

    public var groups: [Group]?

    public func insertDefaultGroup(completion: @escaping (() -> Void)) {
        let defaultGroup = Group(
            title: "기본 폴더",
            visibilityType: .default,
            identifier: UUID(),
            words: [],
            order: -1
        )

        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            let groups = VocaCoreDataManager.shared.fetch(predicate: .default, context: context)
            if groups?.isEmpty ?? true {
                VocaCoreDataManager.shared.insert(group: defaultGroup, context: context)
            }
            completion()
        }
    }

    public func deleteAllGroup() {
        VocaManager.shared.fetch(identifier: nil) { (groups) in
            guard let groups = groups else { return }

            for group in groups {
                VocaManager.shared.delete(group: group)
            }
        }
    }

    public func fetch(
        identifier: UUID?,
        completion: @escaping (([Group]?) -> Void)
    ) {
        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            guard let managedGroups = VocaCoreDataManager.shared.fetch(predicate: identifier, context: context) else {
                completion(nil)
                return
            }

            var groups = [Group]()
            for managedGroup in managedGroups {
                groups.append(managedGroup.toGroup())
            }

            self.groups = groups
            completion(groups)
        }
    }

    public func fetch(
        visibilityType: VisibilityType,
        completion: @escaping (([Group]?) -> Void)
    ) {
        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            guard let managedGroups = VocaCoreDataManager.shared.fetch(predicate: visibilityType, context: context) else {
                completion(nil)
                return
            }

            var groups = [Group]()
            for managedGroup in managedGroups {
                groups.append(managedGroup.toGroup())
            }

            completion(groups)
        }
    }

    public func insert(group: Group, completion: (() -> Void)? = nil) {
        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            VocaCoreDataManager.shared.insert(group: group, context: context)
            guard let completion = completion else {
                return
            }
            completion()
        }
    }

    public func delete(group: Group, completion: (() -> Void)? = nil) {
        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            VocaCoreDataManager.shared.delete(identifier: group.identifier, context: context)
            guard let completion = completion else {
                return
            }
            completion()
        }
    }

    public func update(group: Group, deleteWords: [Word], completion: (() -> Void)? = nil) {
        let currentWords = group.words.filter { (groupWord) -> Bool in
            deleteWords.contains { (word) -> Bool in
                word.identifier != groupWord.identifier
            }
        }

        var currentGroup = group
        currentGroup.words = currentWords

        update(group: currentGroup) {
            guard let completion = completion else {
                return
            }
            completion()
        }
    }

    public func update(group: Group, completion: (() -> Void)? = nil) {
        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            VocaCoreDataManager.shared.update(group: group, context: context) {
                guard let completion = completion else {
                    return
                }
                completion()
            }
        }
    }
    
    public func update(group: Group, addWords: [Word], completion: (() -> Void)? = nil) {
        var currentGroup = group
        var currentWords = addWords

        for index in 0 ..< currentWords.count {
            let wordCount = currentGroup.words.count == 0 ? 0 : currentGroup.words.count - 1
            currentWords[index].order = Int16(index + wordCount)
        }
        
        currentGroup.words.append(contentsOf: currentWords)

        update(group: currentGroup) {
            guard let completion = completion else {
                return
            }
            completion()
        }
    }
}

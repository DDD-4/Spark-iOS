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

    public func fetch(
        identifier: UUID?,
        completion: @escaping (([ManagedGroup]?) -> Void)
    ) {
        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            completion(VocaCoreDataManager.shared.fetch(predicate: identifier, context: context) ?? [])
        }
    }

    public func insert(group: Group) {
        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            VocaCoreDataManager.shared.insert(group: group, context: context)
        }
    }

    public func delete(group: Group) {
        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            VocaCoreDataManager.shared.delete(identifier: group.identifier, context: context)
        }
    }

    public func update(group: Group) {
        VocaCoreDataManager.shared.performBackgroundTask { (context) in
            VocaCoreDataManager.shared.update(group: group, context: context)
        }
    }
}

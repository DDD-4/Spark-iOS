//
//  ManagedGroup+CoreDataProperties.swift
//  Voca
//
//  Created by user on 2020/07/28.
//  Copyright © 2020 Spark. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedGroup> {
        return NSFetchRequest<ManagedGroup>(entityName: "Group")
    }

    @NSManaged public var title: String?
    @NSManaged public var words: NSSet?

}

// MARK: Generated accessors for words
extension ManagedGroup {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: ManagedWord)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: ManagedWord)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}

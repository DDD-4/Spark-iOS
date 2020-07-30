//
//  ManagedGroup+CoreDataProperties.swift
//  Voca
//
//  Created by LEE HAEUN on 2020/07/29.
//  Copyright © 2020 Spark. All rights reserved.
//
//

import Foundation
import CoreData

public enum VisibilityType: String {
    case `public`
    case `private`
    case group
}

public struct Group {
    public init(
        title: String,
        visibilityType: VisibilityType,
        identifier: UUID
    ) {
        self.title = title
        self.visibilityType = visibilityType
        self.identifier = identifier
    }

    public var title: String
    public var visibilityType: VisibilityType
    public var identifier: UUID
}

extension Group {
    func toManaged(context: NSManagedObjectContext) {
        let managed = ManagedGroup(context: context)
        managed.title = title
        managed.visibilityType = visibilityType.rawValue
        managed.identifier = identifier
    }
}

extension ManagedGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedGroup> {
        return NSFetchRequest<ManagedGroup>(entityName: "Group")
    }

    @NSManaged public var title: String?
    @NSManaged public var visibilityType: String?
    @NSManaged public var identifier: UUID?
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

extension ManagedGroup {
    func toGroup() -> Group {
        let isVailableVisibilityType = VisibilityType(rawValue: visibilityType ?? "") ?? .private
        let group = Group(
            title: title ?? "",
            visibilityType: isVailableVisibilityType,
            identifier: UUID()
        )
        return group
    }
}

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
    case `default`
}

public struct Group {
    public init(
        title: String,
        visibilityType: VisibilityType,
        identifier: UUID,
        words: [Word],
        order: Int16
    ) {
        self.title = title
        self.visibilityType = visibilityType
        self.identifier = identifier
        self.words = words
        self.order = order
    }

    public var title: String
    public var visibilityType: VisibilityType
    public var identifier: UUID
    public var words: [Word]
    public var order: Int16
}

extension Group {
    func toManaged(context: NSManagedObjectContext) {

        var managedWords = [ManagedWord]()
        for word in words {
            managedWords.append(word.toManaged(context: context))
        }
        let managed = ManagedGroup(context: context)
        managed.title = title
        managed.visibilityType = visibilityType.rawValue
        managed.identifier = identifier
        managed.words = NSSet(array: managedWords)
        managed.order = order
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
    @NSManaged public var order: Int16
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

        var processedWords = [Word]()
        if let managedWords = words as? Set<ManagedWord> {
            for managedWord in managedWords {
                processedWords.append(managedWord.toWord())
            }

            processedWords = processedWords.sorted {
                $0.order < $1.order
            }
        }

         let isVailableVisibilityType = VisibilityType(rawValue: visibilityType ?? "") ?? .private

        let group = Group(
            title: title ?? "",
            visibilityType: isVailableVisibilityType,
            identifier: identifier ?? UUID(),
            words: processedWords,
            order: order
        )
        return group
    }
}

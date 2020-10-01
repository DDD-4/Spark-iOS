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

public class FolderCoreData: Folder {
    public init(
        name: String,
        visibilityType: VisibilityType,
        identifier: UUID,
        words: [WordCoreData],
        order: Int16
    ) {
        self.identifier = identifier
        self.words = words
        self.order = order
        self.visibilityType = visibilityType

        super.init(
            default: (visibilityType == .default),
            id: -1,
            name: name,
            shareable: (visibilityType == .public),
            photoUrl: ""
        )
    }
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    public var identifier: UUID
    public var words: [WordCoreData]
    public var order: Int16
    public var visibilityType: VisibilityType
}

extension FolderCoreData {
    func toManaged(context: NSManagedObjectContext) {

        var managedWords = [ManagedWord]()
        for word in words {
            managedWords.append(word.toManaged(context: context))
        }
        let managed = ManagedGroup(context: context)
        managed.title = name
        managed.identifier = identifier
        managed.visibilityType = visibilityType.rawValue
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
    func toGroup() -> FolderCoreData {

        var processedWords = [WordCoreData]()
        if let managedWords = words as? Set<ManagedWord> {
            for managedWord in managedWords {
                processedWords.append(managedWord.toWord())
            }

            processedWords = processedWords.sorted {
                $0.order < $1.order
            }
        }

        let isVailableVisibilityType = VisibilityType(rawValue: visibilityType ?? "") ?? .private

        let group = FolderCoreData(
            name: title ?? "",
            visibilityType: isVailableVisibilityType,
            identifier: identifier ?? UUID(),
            words: processedWords,
            order: order
        )
        return group
    }
}

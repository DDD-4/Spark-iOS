//
//  ManagedWord+CoreDataProperties.swift
//  Voca
//
//  Created by user on 2020/07/28.
//  Copyright © 2020 Spark. All rights reserved.
//
//

import Foundation
import CoreData

public struct Word {
    public init(
        korean: String? = nil,
        english: String? = nil,
        image: Date? = nil,
        identifier: UUID? = nil
    ) {
        self.korean = korean
        self.english = english
        self.image = image
        self.identifier = identifier
    }

    public var korean: String?
    public var english: String?
    public var image: Date?
    public var identifier: UUID?

    func toManaged(context: NSManagedObjectContext) -> ManagedWord{
        let managed = ManagedWord(context: context)
        managed.korean = korean
        managed.image = image
        managed.english = english
        managed.identifier = identifier
        return managed
    }
}

extension ManagedWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedWord> {
        return NSFetchRequest<ManagedWord>(entityName: "Word")
    }

    @NSManaged public var korean: String?
    @NSManaged public var english: String?
    @NSManaged public var image: Date?
    @NSManaged public var identifier: UUID?
    @NSManaged public var ofGroup: ManagedGroup?

    func toWord() -> Word {
        Word(korean: korean, english: english, image: image, identifier: identifier)
    }
}

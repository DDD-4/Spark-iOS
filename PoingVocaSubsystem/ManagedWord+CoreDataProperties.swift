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
        image: Data? = nil,
        identifier: UUID? = nil,
        order: Int16
    ) {
        self.korean = korean
        self.english = english
        self.image = image
        self.identifier = identifier
        self.order = order
    }

    public var korean: String?
    public var english: String?
    public var image: Data?
    public var identifier: UUID?
    public var order: Int16

    func toManaged(context: NSManagedObjectContext) -> ManagedWord{
        let managed = ManagedWord(context: context)
        managed.korean = korean
        managed.image = image
        managed.english = english
        managed.identifier = identifier
        managed.order = order
        return managed
    }
}

extension ManagedWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedWord> {
        return NSFetchRequest<ManagedWord>(entityName: "Word")
    }

    @NSManaged public var korean: String?
    @NSManaged public var english: String?
    @NSManaged public var image: Data?
    @NSManaged public var identifier: UUID?
    @NSManaged public var ofGroup: ManagedGroup?
    @NSManaged public var order: Int16

    func toWord() -> Word {
        Word(korean: korean, english: english, image: image, identifier: identifier,order: order)
    }
}

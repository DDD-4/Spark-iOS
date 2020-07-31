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

extension ManagedWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedWord> {
        return NSFetchRequest<ManagedWord>(entityName: "Word")
    }

    @NSManaged public var korean: String?
    @NSManaged public var english: String?
    @NSManaged public var image: Date?
    @NSManaged public var identifier: UUID?
    @NSManaged public var ofGroup: ManagedGroup?

}

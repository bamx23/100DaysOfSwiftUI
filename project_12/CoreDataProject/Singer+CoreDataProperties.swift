//
//  Singer+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Nikolay Volosatov on 11/21/19.
//  Copyright © 2019 BX23. All rights reserved.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

    var wrappedFirstName: String {
        firstName ?? "Unknown"
    }

    var wrappedLastName: String {
        lastName ?? "Unknown"
    }

}

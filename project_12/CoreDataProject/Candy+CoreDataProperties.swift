//
//  Candy+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Nikolay Volosatov on 11/21/19.
//  Copyright © 2019 BX23. All rights reserved.
//
//

import Foundation
import CoreData


extension Candy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?

    public var wrappedName: String {
        name ?? "Unknown Candy"
    }
    
}

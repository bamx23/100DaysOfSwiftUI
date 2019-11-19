//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Nikolay Volosatov on 11/19/19.
//  Copyright © 2019 BX23. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16

    public var wrappedTitle: String {
        return title ?? "Unknown Title"
    }
}

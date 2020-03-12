//
//  BookManagedObject.swift
//  adab
//
//  Created by Daniya on 04/03/2020.
//  Copyright © 2020 nurios. All rights reserved.
//

import CoreData

class BookManagedObject: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var chapters: [String]
    
    static func bookManagedObject(_ title: String, author: String, chapters: [String], context: NSManagedObjectContext) -> BookManagedObject {
        let entity = entityDescription(context)
        let bookManagedObject = BookManagedObject(entity: entity, insertInto: context)
        bookManagedObject.title = title
        bookManagedObject.author = author
        bookManagedObject.chapters = chapters
        return bookManagedObject
    }
    
    private static func entityDescription(_ context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: NSStringFromClass(self), in: context)!
    }
}

//
//  CoreDataHelper.swift
//  adab
//
//  Created by Daniya on 05/10/2019.
//  Copyright © 2019 nurios. All rights reserved.
//

import UIKit
import CoreData

enum MinderType: String {
    case Minder
    case Person
    case Idea
    case Todo
}

struct CoreDataHelper {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }

        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext

        return context
    }()
    
    
    static func newObject<T: NSManagedObject>(_ type: MinderType) -> T {
        let object = NSEntityDescription.insertNewObject(forEntityName: type.rawValue, into: context) as! T

            return object
    }
    
    static func save() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete<T: NSManagedObject>(_ object: T) {
        context.delete(object)
        save()
    }
    
    static func retrieve<T: NSManagedObject>(_ type: MinderType) -> [T] {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: type.rawValue)
            let results = try context.fetch(fetchRequest)

            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")

            return []
        }
    }
}

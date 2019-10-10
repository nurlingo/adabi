//
//  CoreDataHelper.swift
//  adab
//
//  Created by Daniya on 05/10/2019.
//  Copyright © 2019 nurios. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataHelper {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }

        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext

        return context
    }()
    
    
    static func newMinder() -> Minder {
            let minder = NSEntityDescription.insertNewObject(forEntityName: "Minder", into: context) as! Minder

            return minder
    }
    
    static func save() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(minder: Minder) {
        context.delete(minder)
        save()
    }
    
    static func retrieveMinders() -> [Minder] {
        do {
            let fetchRequest = NSFetchRequest<Minder>(entityName: "Minder")
            let results = try context.fetch(fetchRequest)

            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")

            return []
        }
    }
}

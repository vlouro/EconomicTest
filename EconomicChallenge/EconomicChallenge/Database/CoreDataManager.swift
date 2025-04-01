//
//  CoreDataManager.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EconomicChallenge")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    var mainContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
           context.automaticallyMergesChangesFromParent = true
           return context
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}


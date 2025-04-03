//
//  CoreDataManager.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import CoreData

// Class to Manage the Core Data used throughout the app
class CoreDataManager {
    static let shared = CoreDataManager()
    
    // Persistent container for the Core Data
    lazy var persistentContainer: NSPersistentContainer = {
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


//
//  TestCoreDataHelper.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 03/04/2025.
//

import CoreData
@testable import EconomicChallenge

enum TestCoreDataHelper {
    
    /// Clears all Receipt entities from the main context
    static func clearAllReceipts() {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Receipts.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to clear Core Data: \(error)")
        }
    }
    
    static func makeTestReceiptModel(name: String, id: UUID, amount: Double, currency: String) -> Receipt {
        let model = Receipt(
            id: id,
            name: name,
            date: Date(),
            amount: amount,
            currency: currency,
            image: Data(repeating: 0xFF, count: 100)
        )
        
        return model
    }
}

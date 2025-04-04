//
//  ReceiptViewModel.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import UIKit

class ReceiptViewModel {
    
    // Saves a ReceiptModel to Core Data using a background context
    func saveReceipt(_ model: Receipt, completion: (() -> Void)? = nil) {
        let context = CoreDataManager.shared.newBackgroundContext()
        
        context.perform {
            let receipt = Receipts(context: context)
            receipt.id = model.id
            receipt.nameReceipt = model.name
            receipt.date = model.date
            receipt.amount = model.amount
            receipt.currency = model.currency
            receipt.imageData = model.image
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                print("Failed to save receipt: \(error)")
            }
        }
    }
}

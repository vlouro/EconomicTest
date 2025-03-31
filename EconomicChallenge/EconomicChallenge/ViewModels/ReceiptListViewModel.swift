//
//  ReceiptListViewModel.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import UIKit
import CoreData

// Provides data and fetch logic for listing receipts in a CollectionView
class ReceiptListViewModel: NSObject {
    private let context = CoreDataManager.shared.mainContext
    private var fetchedResultsController: NSFetchedResultsController<Receipts>!
    
    override init() {
        super.init()
        let request: NSFetchRequest<Receipts> = Receipts.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    
    // Returns how many receipts are fetched
    func numberOfReceipts() -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    // Returns a Receipt for the UI from Core Data
    func receipt(at index: Int) -> Receipt? {
        guard let receipt = fetchedResultsController.fetchedObjects?[index],
              let imageData = receipt.imageData,
              let image = UIImage(data: imageData),
              let id = receipt.id,
              let name = receipt.nameReceipt,
              let date = receipt.date,
              let currency = receipt.currency
        else { return nil }
        
        return Receipt(
            id: id,
            name: name,
            date: date,
            amount: receipt.amount,
            currency: currency,
            image: image
        )
    }
}

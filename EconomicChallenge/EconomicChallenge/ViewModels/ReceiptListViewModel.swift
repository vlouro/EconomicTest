//
//  ReceiptListViewModel.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import UIKit
import CoreData

// Provides data and fetch logic for listing receipts in a CollectionView
class ReceiptListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    private let context = CoreDataManager.shared.mainContext
    private var fetchedResultsController: NSFetchedResultsController<Receipts>?
    var receipts: [Receipt] = []
    var onChange: (() -> Void)?
    
    override init() {
        super.init()
        
        let request: NSFetchRequest<Receipts> = Receipts.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        
        do {
            try fetchedResultsController?.performFetch()
            if let newReceipts = fetchedResultsController?.fetchedObjects, newReceipts.count > 0 {
                for i in 0..<newReceipts.count {
                    guard let newReceipt = self.createNewReceipt(at: i) else { continue }
                    receipts.append(newReceipt)
                }
            }
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    
    // Returns how many receipts are fetched
    func numberOfReceipts() -> Int {
        return receipts.count
    }
    
    func createNewReceipt(at index: Int) -> Receipt? {
        guard let receipt = fetchedResultsController?.fetchedObjects?[index],
              let imageData = receipt.imageData,
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
            image: imageData
        )
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newReceipt = anObject as? Receipts,
               let image = newReceipt.imageData,
               let id = newReceipt.id,
               let name = newReceipt.nameReceipt,
               let date = newReceipt.date,
               let currency = newReceipt.currency {
                let receipt = Receipt(id: id, name: name, date: date, amount: newReceipt.amount, currency: currency, image: image)
                
                let index = receipts.firstIndex { $0.date < date } ?? receipts.count
                receipts.insert(receipt, at: index)
                onChange?()
            }
        default:
            break
        }
    }
    
}

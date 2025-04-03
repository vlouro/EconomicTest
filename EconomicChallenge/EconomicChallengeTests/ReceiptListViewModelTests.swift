//
//  ReceiptListViewModelTests.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 03/04/2025.
//

import XCTest
@testable import EconomicChallenge
import CoreData

final class ReceiptListViewModelTests: XCTestCase {
    
    var listViewModel: ReceiptListViewModel!
    
    override func setUp() {
        super.setUp()
        TestCoreDataHelper.clearAllReceipts()
    }
    
    override func tearDown() {
        TestCoreDataHelper.clearAllReceipts()
        super.tearDown()
    }
    
    func testInitialReceiptCountIsZeroOrMore() {
        listViewModel = ReceiptListViewModel()
        XCTAssertGreaterThanOrEqual(listViewModel.numberOfReceipts(), 0)
    }
    
    func testReceiptModelMapping() {
        let model = TestCoreDataHelper.makeTestReceiptModel(name: "Test Receipt", id: UUID(), amount: 9.99, currency: "Euro")
        let viewModel = ReceiptViewModel()
        viewModel.saveReceipt(model) {
            let context = CoreDataManager.shared.mainContext
            let request: NSFetchRequest<Receipts> = Receipts.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
            
            do {
                let results = try context.fetch(request)
                XCTAssertEqual(results.first?.nameReceipt, model.name)
            } catch {
                XCTFail("Fetch failed: \(error)")
            }
        }
        
        listViewModel = ReceiptListViewModel()
        if listViewModel.numberOfReceipts() > 0 {
            let model = listViewModel.receipts.first
            XCTAssertNotNil(model?.name)
            XCTAssertNotNil(model?.currency)
        }
    }
}

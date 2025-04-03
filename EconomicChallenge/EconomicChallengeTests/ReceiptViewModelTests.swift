//
//  ReceiptViewModelTests.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 03/04/2025.
//

import XCTest
import CoreData
@testable import EconomicChallenge

final class ReceiptViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        TestCoreDataHelper.clearAllReceipts()
    }
    
    override func tearDown() {
        TestCoreDataHelper.clearAllReceipts()
        super.tearDown()
    }
    
    func testSaveReceipt() {
        let expectation = self.expectation(description: "Receipt saved")
        
        let model = TestCoreDataHelper.makeTestReceiptModel(name: "Test Receipt", id: UUID(), amount: 9.99, currency: "Euro")
        
        let viewModel = ReceiptViewModel()
        viewModel.saveReceipt(model) {
            let context = CoreDataManager.shared.mainContext
            let request: NSFetchRequest<Receipts> = Receipts.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
            
            guard let results = try? context.fetch(request) else {
                XCTFail("Failed to fetch receipts")
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(results.first?.nameReceipt, model.name)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}

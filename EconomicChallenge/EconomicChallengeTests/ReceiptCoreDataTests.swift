//
//  ReceiptCoreDataTests.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 03/04/2025.
//

import XCTest
import CoreData
@testable import EconomicChallenge

final class ReceiptCoreDataTests: XCTestCase {

    override func setUp() {
        super.setUp()
        TestCoreDataHelper.clearAllReceipts()
    }
    
    override func tearDown() {
        TestCoreDataHelper.clearAllReceipts()
        super.tearDown()
    }

    func testSaveReceiptWithNegativeAmount() {
        TestCoreDataHelper.clearAllReceipts()
        let id = UUID()
        let model = TestCoreDataHelper.makeTestReceiptModel(name: "First", id: id, amount: -5.0, currency: "Euro")
        let viewModel = ReceiptViewModel()
        let expectation = self.expectation(description: "Save receipt with negative amount")

        viewModel.saveReceipt(model) {
            let context = CoreDataManager.shared.mainContext
            let request: NSFetchRequest<Receipts> = Receipts.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)

            guard let results = try? context.fetch(request) else {
                XCTFail("Fetch failed")
                expectation.fulfill()
                return
            }

            XCTAssertEqual(results.count, 1, "Negative amounts are allowed")
            XCTAssertEqual(results.first?.amount, -5.0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchEmptyDatabaseReturnsZero() {
        TestCoreDataHelper.clearAllReceipts()

        let context = CoreDataManager.shared.mainContext
        let request: NSFetchRequest<Receipts> = Receipts.fetchRequest()

        guard let results = try? context.fetch(request) else {
            XCTFail("Fetch failed")
            return
        }

        XCTAssertEqual(results.count, 0, "Expected zero receipts")
    }
}


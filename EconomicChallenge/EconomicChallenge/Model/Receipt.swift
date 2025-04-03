//
//  Receipt.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 28/03/2025.
//

import UIKit

struct Receipt {
    let id: UUID
    let name: String
    let date: Date
    let amount: Double
    let currency: String
    let image: Data
}

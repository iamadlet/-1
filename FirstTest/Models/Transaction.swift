//
//  Transaction.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import Foundation

struct TransactionResponse: Decodable {
    let amount: String
    let currency: String
    let sku: String
}

struct Transaction {
    let amount: Double
    let currency: String
    let sku: String
}

extension Transaction {
    init?(data: TransactionResponse) {
        guard let amountValue = Double(data.amount) else { return nil }
        self.amount = amountValue
        self.currency = data.currency
        self.sku = data.sku
    }
}

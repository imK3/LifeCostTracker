//
//  Expense.swift
//  LifeCostTracker
//
//  Created by LifeCostTracker Team
//

import Foundation

struct Expense: Identifiable, Codable {
    let id: UUID
    let amount: Decimal
    let category: ExpenseCategory
    let date: Date
    let notes: String?
    let receiptPhotoURL: URL?
    let estimatedUsageDays: Int? // For daily cost calculation (optional for one-time expenses)
    
    var dailyCost: Decimal? {
        guard let days = estimatedUsageDays, days > 0 else { return nil }
        return amount / Decimal(days)
    }
    
    init(
        id: UUID = UUID(),
        amount: Decimal,
        category: ExpenseCategory,
        date: Date = Date(),
        notes: String? = nil,
        receiptPhotoURL: URL? = nil,
        estimatedUsageDays: Int? = nil
    ) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.notes = notes
        self.receiptPhotoURL = receiptPhotoURL
        self.estimatedUsageDays = estimatedUsageDays
    }
}

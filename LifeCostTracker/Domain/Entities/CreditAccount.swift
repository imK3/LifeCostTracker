//
//  CreditAccount.swift
//  LifeCostTracker
//
//  Created by LifeCostTracker Team
//

import Foundation

struct CreditAccount: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: CreditAccountType
    let balance: Decimal
    let creditLimit: Decimal?
    let apr: Double?
    let dueDate: Date?
    let minimumPayment: Decimal?
    
    var creditUtilization: Double? {
        guard let limit = creditLimit, limit > 0 else { return nil }
        return Double(balance / limit)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        type: CreditAccountType,
        balance: Decimal,
        creditLimit: Decimal? = nil,
        apr: Double? = nil,
        dueDate: Date? = nil,
        minimumPayment: Decimal? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.balance = balance
        self.creditLimit = creditLimit
        self.apr = apr
        self.dueDate = dueDate
        self.minimumPayment = minimumPayment
    }
}

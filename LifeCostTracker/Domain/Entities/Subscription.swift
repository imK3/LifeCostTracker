//
//  Subscription.swift
//  LifeCostTracker
//
//  Created by LifeCostTracker Team
//

import Foundation

struct Subscription: Identifiable, Codable {
    let id: UUID
    let name: String
    let cost: Decimal
    let billingCycle: BillingCycle
    let nextBillingDate: Date
    let category: SubscriptionCategory
    let isFreeTrial: Bool
    let freeTrialEndDate: Date?
    
    var dailyCost: Decimal {
        return cost / Decimal(billingCycle.daysInCycle)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        cost: Decimal,
        billingCycle: BillingCycle,
        nextBillingDate: Date,
        category: SubscriptionCategory,
        isFreeTrial: Bool = false,
        freeTrialEndDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.cost = cost
        self.billingCycle = billingCycle
        self.nextBillingDate = nextBillingDate
        self.category = category
        self.isFreeTrial = isFreeTrial
        self.freeTrialEndDate = freeTrialEndDate
    }
}

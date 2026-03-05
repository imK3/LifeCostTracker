//
//  CreditAccountType.swift
//  LifeCostTracker
//
//  Created by LifeCostTracker Team
//

import Foundation

enum CreditAccountType: String, CaseIterable, Codable {
    case creditCard
    case personalLoan
    case studentLoan
    case installmentPlan
    
    var displayName: String {
        switch self {
        case .creditCard:
            return "信用卡"
        case .personalLoan:
            return "个人贷款"
        case .studentLoan:
            return "学生贷款"
        case .installmentPlan:
            return "分期付款"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .creditCard:
            return "creditcard"
        case .personalLoan:
            return "banknote"
        case .studentLoan:
            return "graduationcap"
        case .installmentPlan:
            return "calendar"
        }
    }
}

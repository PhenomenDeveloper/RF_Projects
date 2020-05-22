//
//  NetworkHistoryModelWithLogo.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 13.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

// MARK: - Структуры для парсинга JSON

protocol TransactionWithLogoProtocol {
    var date: Date {get}
    var pan: String {get}
    var merchant: String {get}
    var merchantLogoId: String? {get}
    var site: String? {get}
    var amount: Double {get}
    var symbol: String {get}
}

struct TransactionList: Codable {
    var list: [Transaction]

    struct Transaction: Codable {
        var date: Date
        var pan: String
        var merchant: String
        var merchantLogoId: String?
        var site: String?
        var amount: Double
        var billCurrency: Currency

        struct Currency: Codable {
            var symbol: String
        }
    }
}

// MARK: - Структура для работы с нужными данными полученными из JSON

struct TransactionWithLogo: TransactionWithLogoProtocol {
    var date: Date
    var pan: String
    var merchant: String
    var merchantLogoId: String?
    var site: String?
    var amount: Double
    var symbol: String
}

//
//  RealmTransactions.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmTransactionProtocol {
    var date: Date {get}
    var secureCardNumber: String {get}
    var merchant: String {get}
    var merchantLogoId: String? {get}
    var site: String? {get}
    var amount: Double {get}
    var currencySymbol: String {get}
}

class RealmTransaction: Object, RealmTransactionProtocol {
    @objc dynamic var date: Date = Date(timeIntervalSince1970: 1)
    @objc dynamic var secureCardNumber: String = ""
    @objc dynamic var merchant: String = ""
    @objc dynamic var merchantLogoId: String?
    @objc dynamic var site: String?
    @objc dynamic var amount: Double = 0
    @objc dynamic var currencySymbol: String = ""
}

//
//  LoadTransactionsWithLogo.swift
//  BankUITests
//
//  Created by OMELCHUK Daniil on 22.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest
@testable import BankUI

class LoadTransactionsWithLogoTests: XCTestCase {
    
    var networkServiceSut: NetworkService!
    var dataFetcherSut: NetworkDataFetcher!
    
    override func setUp() {
        networkServiceSut = NetworkService()
        dataFetcherSut = NetworkDataFetcher(networking: networkServiceSut)
    }

    override func tearDown() {
        networkServiceSut = nil
    }
    
    func testLoadTransactionsWithLogo() {
        
        networkServiceSut.getHistoryDataWithLogo(path: APINetwork.historyWithLogo, params: [:]) { (data, error) in
            XCTAssertNotNil(data, "Данные не должны быть nil")
            XCTAssertNil(error, "error должна быть nil")
        }
    }
    
    func testDecodedLoadTransactionsWithLogoIntoModel() {
        
        dataFetcherSut.getHistoryDataWithLogo { (transactions) in
            XCTAssertNotNil(transactions)
            XCTAssertTrue(transactions!.list.count > 0)
            
            let model = TransactionWithLogo(date: transactions!.list.first!.date,
                                            pan: transactions!.list.first!.pan,
                                            merchant: transactions!.list.first!.merchant,
                                            merchantLogoId: transactions!.list.first!.merchantLogoId,
                                            site: transactions!.list.first!.site,
                                            amount: transactions!.list.first!.amount,
                                            symbol: transactions!.list.first!.billCurrency.symbol)
            
            XCTAssertNotNil(model.amount)
            XCTAssertNotNil(model.date)
            XCTAssertNotNil(model.merchant)
            XCTAssertNotNil(model.pan)
            XCTAssertNotNil(model.symbol)
        }
    }
}

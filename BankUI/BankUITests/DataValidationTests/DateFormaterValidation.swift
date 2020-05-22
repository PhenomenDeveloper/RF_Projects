//
//  DateFormaterValidation.swift
//  BankUITests
//
//  Created by OMELCHUK Daniil on 22.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest
@testable import BankUI

class DateFormatterValidation: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHistoryTransactionDateFormatterFromJson() {
        let dateFormatter = DateFormatter.historyDateFormatFromJson
        let date = dateFormatter.date(from: "2019-04-09T11:30:25.000+03:00")
        
        let transactionsFormatter = DateFormatter.transactionsDataFormat
        XCTAssertEqual(transactionsFormatter.string(from: date!), "9 апреля 2019")
    }
    
    func testHistoryTransactionDateFormatterFromJsonWithUncorrectData() {
        let dateFormatter = DateFormatter.historyDateFormatFromJson
        let date = dateFormatter.date(from: "2019-13-09T11:30:25.000+03:00")
        
        XCTAssertNil(date)
    }
    
    func testHistoryTransactionDateWithLogoFormatterFromJson() {
        let dateFormatter = DateFormatter.historyDataFormatWithLogoFromJson
        let date = dateFormatter.date(from: "2019-04-07T00:00")
        
        let transactionsFormatter = DateFormatter.transactionsDataFormat
        XCTAssertEqual(transactionsFormatter.string(from: date!), "7 апреля 2019")
    }
    
    func testHistoryTransactionDateWithLogoFormatterFromJsonWithUncorrectData() {
        let dateFormatter = DateFormatter.historyDataFormatWithLogoFromJson
        let date = dateFormatter.date(from: "2019-13-07T00:00")
        
        XCTAssertNil(date)
    }
    
    func testHistoryTransactionDateFormatterFromJsonEmpty() {
        let dateFormatter = DateFormatter.historyDateFormatFromJson
        let date = dateFormatter.date(from: "")
        
        XCTAssertNil(date)
    }
}

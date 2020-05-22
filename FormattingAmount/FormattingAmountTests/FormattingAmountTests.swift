//
//  FormattingAmountTests.swift
//  FormattingAmountTests
//
//  Created by KOLESNIKOV Lev on 22.01.2020.
//  Copyright © 2020 SwiftOverflow. All rights reserved.
//

import XCTest
@testable import FormattingAmount

class FormattingAmountTests: XCTestCase {
    
    var sut: AmountFormatter!
    
    override func setUp() {
        sut = AmountFormatter()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testValidFormattingRubAmount() {
        let amount: Decimal? = 1000000.99
        
        XCTAssertEqual(sut.formatter(amount: amount, currency: .rub), Optional("1 000 000,99 ₽"), "Не удалось преобразовать сумму рублей к нужному формату")
        
    }
    
    func testValidFormattingUsdAmount() {
        let amount: Decimal? = 9230.00
        
        XCTAssertEqual(sut.formatter(amount: amount, currency: .usd), Optional("9 230 $"), "Не удалось преобразовать сумму долларов к нужному формату")
        
    }
    
    func testValidFormattingEurAmount() {
        let amount: Decimal? = 57201.20
        
        XCTAssertEqual(sut.formatter(amount: amount, currency: .eur), Optional("57 201,2 €"), "Не удалось преобразовать сумму евро к нужному формату")
        
    }
    
    func testValidFormattingWithNegativeRubAmount() {
        let amount: Decimal? = -17304.12
    
        XCTAssertEqual(sut.formatter(amount: amount, currency: .rub), Optional("-17 304,12 ₽"), "Не удалось преобразовать отрицательную сумму рублей к нужному формату")
    }
    
    func testValidFormattingRubWholeAmount() {
        let amount: Decimal? = 10112232
        
        XCTAssertEqual(sut.formatter(amount: amount, currency: .usd), Optional("10 112 232 $"), "Не удалось преобразовать целочисленную сумму долларов к нужному формату")
    }
    
    func testNilRubNumber() {
        let amount: Decimal? = nil

        XCTAssertEqual(sut.formatter(amount: amount, currency: .rub), Optional("0,00 ₽"), "Вместо суммы пришел nil")

    }
    
}



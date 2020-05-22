//
//  UIColorTests.swift
//  BankUITests
//
//  Created by KOLESNIKOV Lev on 23.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest
@testable import BankUI

class UIColorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // MARK: - Тестирование Extension для UIColor, которое из строки с hex получает объект UIColor
    func testConvertHexToUIColorWithAlpha() {
        let resultColor = UIColor(red: 255 / 255, green: 219 / 255, blue: 0, alpha: 0.7)
        let hexColor: String = "#ffdb00"
        
        let testableColor = UIColor(hexString: hexColor, alpha: 0.7)
        XCTAssertNotNil(testableColor)
        XCTAssertNotNil(resultColor)
        
        XCTAssertEqual(testableColor, resultColor)
    }
    
    func testConvertEmptyHexToUIColorWithAlpha() {
        let resultColor = UIColor(red: 255 / 255, green: 219 / 255, blue: 0, alpha: 0.7)
        let hexColor: String = ""
        
        let testableColor = UIColor(hexString: hexColor, alpha: 0.7)
        XCTAssertNotNil(testableColor)
        XCTAssertNotNil(resultColor)
        
        XCTAssertNotEqual(testableColor, resultColor)
    }
    
//    func testIncorrectHexValue() {
//        let resultColor = UIColor(red: 255 / 255, green: 219 / 255, blue: 0, alpha: 0.7)
//        let hexColor: String = ""
//        
//        let testableColor = UIColor(hexString: hexColor, alpha: 0.7)
////        XCTAssertNotNil(testableColor)
////        XCTAssertNotNil(resultColor)
//        
//        XCTAssertEqual(testableColor, resultColor)
//    }
    
    // попробовать не корректный
}

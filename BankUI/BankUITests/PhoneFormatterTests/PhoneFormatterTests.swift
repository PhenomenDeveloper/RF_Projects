//
//  PhoneFormatterTests.swift
//  BankUITests
//
//  Created by KOLESNIKOV Lev on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest
@testable import BankUI

class PhoneFormatterTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEmptyNumber() {
        let inputNumber: String? = ""
        let properNumber: String = "Пустой номер"
        
        let result = inputNumber?.toPhoneNumber()
        
        XCTAssertEqual(properNumber, result)
    }
    
    func testFormattedNumber() {
        let inputNumber: String? = "+7 (903) 000-13-00"
        let properNumber: String = "+7 (903) 000-13-00"
        
        let result = inputNumber?.toPhoneNumber()
        
        XCTAssertEqual(properNumber, result)
    }
    
    func testNumberStartWithEight() {
        let inputNumber: String? = "89030001300"
        let properNumber: String = "+7 (903) 000-13-00"
        
        let result = inputNumber?.toPhoneNumber()
        
        XCTAssertEqual(properNumber, result)
    }
    
    func testNumberStartWithSeven() {
        let inputNumber: String? = "79030001300"
        let properNumber: String = "+7 (903) 000-13-00"
        
        let result = inputNumber?.toPhoneNumber()
        
        XCTAssertEqual(properNumber, result)
    }
    
    func testNumberStartWithPlusSeven() {
        let inputNumber: String? = "+79030001300"
        let properNumber: String = "+7 (903) 000-13-00"
        
        let result = inputNumber?.toPhoneNumber()
        
        XCTAssertEqual(properNumber, result)
    }
    
    func testNumberStartWithNine() {
        let inputNumber: String? = "9030001300"
        let properNumber: String = "+7 (903) 000-13-00"
        
        let result = inputNumber?.toPhoneNumber()
        
        XCTAssertEqual(properNumber, result)
    }
    
    func testNumberWithLetters() {
        let inputNumber: String? = "CallMe79030001300PLS"
        let properNumber: String = "+7 (903) 000-13-00"
        
        let result = inputNumber?.toPhoneNumber()
        
        XCTAssertEqual(properNumber, result)
    }

}

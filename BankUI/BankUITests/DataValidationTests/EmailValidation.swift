//
//  EmailValidation.swift
//  BankUITests
//
//  Created by MANVELYAN Gevorg on 22.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest
@testable import BankUI

class EmailValidation: XCTestCase {

    var sut: RegistrationMenu!
    
    override func setUp() {
        sut = RegistrationMenu()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProperEmail() {
        let emailTyped: String? = "gevorg0894@gmail.com"
        let result = sut.isValidateEmail(email: emailTyped)
        XCTAssertTrue(result)
    }
    
    func testEmailWithoutAt() {
        let emailTyped: String? = "gevorg0894gmail.com"
        let result = sut.isValidateEmail(email: emailTyped)
        XCTAssertFalse(result)
    }
    
    func testEmailWithoutDot() {
        let emailTyped: String? = "gevorg0894@gmailcom"
        let result = sut.isValidateEmail(email: emailTyped)
        XCTAssertFalse(result)
    }
    
    func testEmailWithoutDomain() {
        let emailTyped: String? = "gevorg9408@"
        let result = sut.isValidateEmail(email: emailTyped)
        XCTAssertFalse(result)
    }

    func testEmailWithoutAfterDot() {
        let emailTyped: String? = "gevorg0894@gmail."
        let result = sut.isValidateEmail(email: emailTyped)
        XCTAssertFalse(result)
    }
    
    func testEmailWithoutBeforeAt() {
        let emailTyped: String? = "@gmail.com"
        let result = sut.isValidateEmail(email: emailTyped)
        XCTAssertFalse(result)
    }
    
    func testEmailNil() {
        let emailTyped: String? = nil
        let result = sut.isValidateEmail(email: emailTyped)
        XCTAssertFalse(result)
    }
    
    func testEmailEmpty() {
        let emailTyped: String? = ""
        let result = sut.isValidateEmail(email: emailTyped)
        XCTAssertFalse(result)
    }
}

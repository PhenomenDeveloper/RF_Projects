//
//  ConversionDegreesTests.swift
//  BankUITests
//
//  Created by KOLESNIKOV Lev on 23.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest
@testable import BankUI

class ConversionDegreesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // MARK: - Тестирование Extension для Double, которое конвертирует из градусов в радианы и наоборот
    func testConvertDegreesToRadians() {
        let degrees: Double = 65.0
        let radians: Double = degrees.degreesToRadians
        XCTAssertNotNil(radians)
        
        XCTAssertEqual(radians, 1.1344640137963142)
        
    }
    
    func testConvertRadiansToDegrees() {
        let radians: Double = 1.1344640137963142
        let degrees: Double = radians.radiansToDegrees
        XCTAssertNotNil(degrees)
        
        XCTAssertEqual(degrees, 65.0)
        
    }
    
    

}

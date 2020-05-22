//
//  ImageNameTests.swift
//  BankUITests
//
//  Created by KOLESNIKOV Lev on 23.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest
@testable import BankUI

class ImageNameTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClippingImageName() {
        let imageUrlStr: String = "/import/statement/butterfly.png"
        let clipUrlStr: String? = imageUrlStr.getImageName()
        XCTAssertNotNil(clipUrlStr)
        
        XCTAssertEqual(clipUrlStr, "/butterfly.png")
    }
    
    func testCorruptedImageUrl() {
        let imageUrlStr: String = "impor/stateme/death.png"
        let clipUrlStr: String? = imageUrlStr.getImageName()
        XCTAssertNotNil(clipUrlStr)
        
        XCTAssertNotEqual(clipUrlStr, "death.png")
        XCTAssertEqual(clipUrlStr, "ErrorName.png")
    }
    
    func testEmptyImageUrl() {
        let imageUrlStr: String = ""
        let clipUrlStr: String? = imageUrlStr.getImageName()
        
        XCTAssertNil(clipUrlStr)
    }
}

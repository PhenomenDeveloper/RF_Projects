//
//  UserDataTests.swift
//  BankUIUITests
//
//  Created by MANVELYAN Gevorg on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest

class BankUI02_UserDataTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
        
        login()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func login() {
        app.staticTexts["1"].tap()
        app.staticTexts["1"].tap()
        app.staticTexts["1"].tap()
        app.staticTexts["1"].tap()
    }
        
    func test01CorrectDataInInboxVC() {
        
        app.tabBars.buttons["История"].tap()
        
        let tablesQuery = app.tables
        
        sleep(6)
        
        XCTAssertTrue(tablesQuery.staticTexts["6 апреля 2019"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["5 апреля 2019"].exists)
        
        XCTAssertTrue(tablesQuery.cells["InboxWithLogoCell"].firstMatch.staticTexts["Операция по карте *3649"].exists)
        
    }
    
    func test02CheckUserDataAfterLogin() {
        
        XCTAssertTrue(app.staticTexts["Евгений А."].exists)
        XCTAssertTrue(app.staticTexts["+7 (926) 526-19-69"].exists)
        XCTAssertTrue(app.staticTexts["e@antropov.it"].exists)
    }
    
    func test03CheckBalanceCellInHeader() {
        
        app.collectionViews.cells["HeaderCell"].firstMatch.swipeLeft()
        XCTAssertTrue((app.collectionViews.cells["HeaderCell"].staticTexts["Баланс #всёсразу"].exists))
        app.collectionViews.cells["HeaderCell"].firstMatch.swipeRight()
    }
    
    
    func test04CheckSettingsTransition() {
        
        app.tables.cells.staticTexts["Настройки входа"].firstMatch.tap()
        
        XCTAssertTrue(app.navigationBars.staticTexts["Настройки"].exists)
        
    }
    
}

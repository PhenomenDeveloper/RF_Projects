//
//  StreetballTests.swift
//  BankUIUITests
//
//  Created by MANVELYAN Gevorg on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest

class BankUI03_StreetballTests: XCTestCase {
    
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
    
    ///Тест входа в модуль стритбола
    func test01StreetballEnter() {
        
        app.tables.staticTexts["Райффайзен Банк Лига 3х3"].tap()
        
        let navBarLabel = app.navigationBars["BankUI.StreetBallBaseVC"]
        sleep(1)
        XCTAssertTrue(navBarLabel.staticTexts["Райффайзенбанк Лига 3 Х 3"].exists)
    }
    
    ///Вход на экран команды
    func test02StreetballTeamBamboo() {
        
        app.tables.staticTexts["Райффайзен Банк Лига 3х3"].tap()
        
        app.tables.cells["TournamentCell"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Бамбу"].exists)
        
    }
    
    ///Вход на экран игрока
    func test03StreetballPlayer() {
        
        app.tables.staticTexts["Райффайзен Банк Лига 3х3"].tap()
        
        app.tables.cells["TournamentCell"].firstMatch.tap()
        app.tables.cells["TeamCell"].firstMatch.tap()
        
        XCTAssertTrue(app.staticTexts["Боткин\nГенадий"].exists)
        
    }
    
    ///Проверка переключения между экранами турнирной таблицы и календаря
    func test04StreetballSegmentedControl() {
        
        app.tables.staticTexts["Райффайзен Банк Лига 3х3"].tap()
        
        // given
        let navBarSegmentedControl = app.navigationBars["BankUI.StreetBallBaseVC"]
        let tournamentButton = navBarSegmentedControl.buttons["Турнирная таблица"]
        let calendarButton = navBarSegmentedControl.buttons["Календарь"]
        
        navBarSegmentedControl.buttons["Турнирная таблица"].tap()
        navBarSegmentedControl.buttons["Календарь"].tap()
        
        
        // then
        if tournamentButton.isSelected {
            XCTAssertTrue(app.tables.cells["TournamentCell"].firstMatch.exists)
            XCTAssertFalse(app.tables.cells["CalendarCell"].firstMatch.exists)
            calendarButton.tap()
            
            XCTAssertTrue(app.tables.cells["CalendarCell"].firstMatch.exists)
            XCTAssertFalse(app.tables.cells["TournamentCell"].firstMatch.exists)
        } else if calendarButton.isSelected {
            XCTAssertTrue(app.tables.cells["CalendarCell"].firstMatch.exists)
            XCTAssertFalse(app.tables.cells["TournamentCell"].firstMatch.exists)
            tournamentButton.tap()
            XCTAssertTrue(app.tables.cells["TournamentCell"].firstMatch.exists)
            XCTAssertFalse(app.tables.cells["CalendarCell"].firstMatch.exists)
        }
    }
    
    ///Проверка предстоящих игр
    func test05StreetballCalendarStatusFutureGame() {
                
        let navBarSegmentedControl = app.navigationBars["BankUI.StreetBallBaseVC"]
        let calendarButton = navBarSegmentedControl.buttons["Календарь"]
        
        app.tables.staticTexts["Райффайзен Банк Лига 3х3"].tap()
        calendarButton.tap()
        app.buttons["Forward"].tap()
        
        
        XCTAssertTrue(app.tables.cells["CalendarCell"].firstMatch.staticTexts["Запланирована"].exists)
    }
    
    ///Проверка прошедших игр
    func test06StreetballCalendarStatusPreviousGame() {
        
        let navBarSegmentedControl = app.navigationBars["BankUI.StreetBallBaseVC"]
        let calendarButton = navBarSegmentedControl.buttons["Календарь"]
        
        app.tables.staticTexts["Райффайзен Банк Лига 3х3"].tap()
        calendarButton.tap()
        app.buttons["Back"].tap()
        
        XCTAssertTrue(app.tables.cells["CalendarCell"].firstMatch.staticTexts["Завершена"].exists)
        
    }
}


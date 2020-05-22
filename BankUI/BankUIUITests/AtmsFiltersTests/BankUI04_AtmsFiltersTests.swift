//
//  BankUI04_AtmsFiltersTests.swift
//  BankUIUITests
//
//  Created by MANVELYAN Gevorg on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest

class BankUI04_AtmsFiltersTests: XCTestCase {
    var app: XCUIApplication!


    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()

    }

    ///Логин в приложении
    func login() {
        app.staticTexts["1"].tap()
        app.staticTexts["1"].tap()
        app.staticTexts["1"].tap()
        app.staticTexts["1"].tap()
    }

    ///Проверяет что данные о Банкоматах и Метро загрузятся и отобразятся
    func test01CheckLoadATMsAndSubwaysData() {
        login()
        app.collectionViews.cells["AddressCell"].firstMatch.tap()

        let cellDepartment = app.tables.cells["ATMsCellDepartment"]
        let cellAtm = app.tables.cells["ATMsCellAtm"]
        let cellTerminal = app.tables.cells["ATMsCellTerminal"]
        let exists = NSPredicate(format: "exists == 1")
        let departmentExpectation = expectation(for: exists, evaluatedWith: cellDepartment, handler: nil)
        let atmExpectation = expectation(for: exists, evaluatedWith: cellAtm, handler: nil)
        let terminalExpectation = expectation(for: exists, evaluatedWith: cellTerminal, handler: nil)


        let result = XCTWaiter().wait(for: [departmentExpectation, atmExpectation, terminalExpectation], timeout: 90)

        switch result {
        case .completed:
            XCTAssertTrue(cellDepartment.firstMatch.exists || cellAtm.firstMatch.exists || cellTerminal.firstMatch.exists)
        case .timedOut:
            XCTAssertTrue(cellDepartment.firstMatch.exists || cellAtm.firstMatch.exists || cellTerminal.firstMatch.exists)
        default:
            XCTAssertTrue(cellDepartment.firstMatch.exists || cellAtm.firstMatch.exists || cellTerminal.firstMatch.exists)
        }
    }

    ///Проверяет что в открывшейся карточке присутствуют данные из нажатой ячейки
    func test02CheckBottomCardInfo() {
        login()
        app.collectionViews.cells["AddressCell"].firstMatch.tap()

        var atmCell: XCUIElement!
        for i in 0..<3 {
            switch i {
            case 0:
                atmCell = app.tables.cells["ATMsCellDepartment"].firstMatch
            case 1:
                atmCell = app.tables.cells["ATMsCellAtm"].firstMatch
            case 2:
                atmCell = app.tables.cells["ATMsCellTerminal"].firstMatch
            default:
                return
            }
            if atmCell.exists {
                break
            }
        }

        let address = atmCell.staticTexts["ATMsCellAddress"].label
        let distance = atmCell.staticTexts["ATMsCellDistance"].label


        atmCell?.tap()

        let bottomCardHeaderCell = app.tables.cells["BottomCardCellHeader"].firstMatch
        XCTAssertEqual(distance, bottomCardHeaderCell.staticTexts["BottomCardDistance"].label)

        let bottomCardAddressCell = app.tables.cells["BottomCardCellAddress"].firstMatch
        XCTAssertEqual(address, bottomCardAddressCell.staticTexts["BottomCardAddress"].label)

    }

    ///Проверяет что после применения фильтра для отображения только Отделений, будут отобрадаться только Отделения
    func test03CheckDepartmentsFilters() {
        login()
        app.collectionViews.cells["AddressCell"].firstMatch.tap()

        app.buttons["FiltersButton"].firstMatch.tap()

        sleep(5)

        for i in 0..<app.tables.cells.count {
            let cell = app.cells.containing(.cell, identifier: "FilterCell").element(boundBy: i)

            if  cell.staticTexts["FilterCellName"].label == "Банкоматы" ||
                cell.staticTexts["FilterCellName"].label == "Терминалы"
                {
                uncheckFilter(cell: cell)
            }
            if cell.staticTexts["FilterCellName"].label == "Отделения" {
                checkFilter(cell: cell)
            }
        }

        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertFalse(app.tables.cells["ATMsCellAtm"].exists)
        XCTAssertFalse(app.tables.cells["ATMsCellTerminal"].exists)

    }

    ///Проверяет что после применения фильтра для отображения только Банкоматов, будут отобрадаться только Бакноматы
    func test04CheckATMFilters() {
        login()
        app.collectionViews.cells["AddressCell"].firstMatch.tap()

        app.buttons["FiltersButton"].firstMatch.tap()
        sleep(5)

        for i in 0..<app.tables.cells.count {
            let cell = app.cells.containing(.cell, identifier: "FilterCell").element(boundBy: i)
            if  cell.staticTexts["FilterCellName"].label == "Отделения" ||
                cell.staticTexts["FilterCellName"].label == "Терминалы"
                {
                uncheckFilter(cell: cell)
                continue
            }
            if cell.staticTexts["FilterCellName"].label == "Банкоматы" {
                checkFilter(cell: cell)
            }
        }

        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertFalse(app.tables.cells["ATMsCellDepartment"].exists)
        XCTAssertFalse(app.tables.cells["ATMsCellTerminal"].exists)

    }

    ///Проверяет что после применения фильтра для отображения только Терминалов, будут отобрадаться только Терминалы
    func test05CheckTerminalFilters() {
        login()
        app.collectionViews.cells["AddressCell"].firstMatch.tap()

        app.buttons["FiltersButton"].firstMatch.tap()
        sleep(5)

        for i in 0..<app.tables.cells.count {
            let cell = app.cells.containing(.cell, identifier: "FilterCell").element(boundBy: i)
            if  cell.staticTexts["FilterCellName"].label == "Отделения" ||
                cell.staticTexts["FilterCellName"].label == "Банкоматы"
                {
                uncheckFilter(cell: cell)
                    continue
            }
            if cell.staticTexts["FilterCellName"].label == "Терминалы" {
                checkFilter(cell: cell)
            }
        }

        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertFalse(app.tables.cells["ATMsCellDepartment"].exists)
        XCTAssertFalse(app.tables.cells["ATMsCellAtm"].exists)

    }

    ///Проверяет поведение, если пользователь не выберет ни одного фильтра
    func test06CheckNoFilters() {
        login()
        app.collectionViews.cells["AddressCell"].firstMatch.tap()

        app.buttons["FiltersButton"].firstMatch.tap()
        sleep(5)

        for i in 0..<app.tables.cells.count {
            let cell = app.cells.containing(.cell, identifier: "FilterCell").element(boundBy: i)
            if  cell.staticTexts["FilterCellName"].label == "Отделения" ||
                cell.staticTexts["FilterCellName"].label == "Банкоматы" ||
                cell.staticTexts["FilterCellName"].label == "Терминалы"
                {
                uncheckFilter(cell: cell)
            }
        }

        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertFalse(app.tables.cells["ATMsCellTerminal"].exists)
        XCTAssertFalse(app.tables.cells["ATMsCellDepartment"].exists)
        XCTAssertFalse(app.tables.cells["ATMsCellAtm"].exists)

    }

    ///Проверяет поведение, если пользователь выберет все фильтры
    func test07CheckAllFilters() {
        login()
        app.collectionViews.cells["AddressCell"].firstMatch.tap()

        app.buttons["FiltersButton"].firstMatch.tap()
        sleep(5)

        for i in 0..<app.tables.cells.count {
            let cell = app.cells.containing(.cell, identifier: "FilterCell").element(boundBy: i)
            if cell.staticTexts["FilterCellName"].label == "Отделения"  ||
                cell.staticTexts["FilterCellName"].label == "Банкоматы" ||
                cell.staticTexts["FilterCellName"].label == "Терминалы"
                {
                checkFilter(cell: cell)
            }
        }

        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertTrue(app.tables.cells["ATMsCellTerminal"].exists || app.tables.cells["ATMsCellDepartment"].exists || app.tables.cells["ATMsCellDepartment"].exists)
    }

    private func uncheckFilter(cell: XCUIElement) {
        if cell.buttons["FilterCellButton"].isSelected {
            cell.buttons["FilterCellButton"].tap()
        }
    }

    private func checkFilter(cell: XCUIElement) {
        if !cell.buttons["FilterCellButton"].isSelected {
            cell.buttons["FilterCellButton"].tap()
        }
    }
}

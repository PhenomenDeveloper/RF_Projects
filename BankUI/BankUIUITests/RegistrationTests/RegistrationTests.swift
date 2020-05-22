//
//  RegistrationTests.swift
//  BankUIUITests
//
//  Created by MANVELYAN Gevorg on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest

class BankUI01_RegistrationTests: XCTestCase {
   var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        app = XCUIApplication()
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test01CheckRegistrationWithoutPhoneTextField() {
        
        let loginTF = app.textFields["Логин от интернет-банка"]
        loginTF.tap()
        loginTF.typeText("Login")
        
        
        let passwordTF = app.secureTextFields["Пароль"]
        passwordTF.tap()
        passwordTF.typeText("pass123")
        
        let pinTF = app.secureTextFields["ПИН"]
        pinTF.tap()
        pinTF.typeText("1111")
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .staticText)["Регистрация"].tap()
        
        let emailTF = app.textFields["Email"]
        emailTF.tap()
        emailTF.typeText("gevorg0894@gmail.com")
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .staticText)["Регистрация"].tap()
        
        app.buttons["Регистрация"].tap()
        
        XCTAssertFalse(app.staticTexts["PIN"].exists)
        
    }
    
    func test02Registration() {
        
        
        let loginTF = app.textFields["Логин от интернет-банка"]
        loginTF.tap()
        loginTF.typeText("Login")
        
        
        let passwordTF = app.secureTextFields["Пароль"]
        passwordTF.tap()
        passwordTF.typeText("pass123")
        
        let pinTF = app.secureTextFields["ПИН"]
        pinTF.tap()
        pinTF.typeText("1111")
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .staticText)["Регистрация"].tap()
        
        let emailTF = app.textFields["Email"]
        emailTF.tap()
        emailTF.typeText("gevorg0894@gmail.com")
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .staticText)["Регистрация"].tap()
        
        let phoneTF = app.textFields["Номер телефона"]
        phoneTF.tap()
        phoneTF.typeText("89296558548")
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .staticText)["Регистрация"].tap()
        
        app.buttons["Регистрация"].tap()
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["PIN"].exists)
    }
    
    
    func test03Login() {
        
        app.staticTexts["1"].tap()
        app.staticTexts["1"].tap()
        app.staticTexts["1"].tap()
        app.staticTexts["1"].tap()
        
        XCTAssertTrue(app.navigationBars["Еще"].staticTexts["Еще"].exists)
    }
    
    func test04WrongPin() {
        
        app.staticTexts["1"].tap()
        app.staticTexts["2"].tap()
        app.staticTexts["3"].tap()
        app.staticTexts["4"].tap()
        
        XCTAssertFalse(app.navigationBars["Еще"].staticTexts["Еще"].exists)
        
    }
    
    func test05Logout() {
        
        test03Login()
        
        app.buttons["exit"].tap()
        
        XCTAssertTrue(app.staticTexts["Регистрация"].exists)
    }
    
    func test06CheckSettingsData() {
        
        test02Registration()
        test03Login()
        
        app.tabBars.buttons["Настройки"].tap()
        
        XCTAssert(app.textFields["gevorg0894@gmail.com"].exists)
        XCTAssert(app.textFields["+7 (929) 655-85-48"].exists)
        
    }
}

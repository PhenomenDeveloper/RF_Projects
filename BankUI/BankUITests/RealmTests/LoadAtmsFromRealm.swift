//
//  LoadAtmsFromRealm.swift
//  BankUITests
//
//  Created by OMELCHUK Daniil on 22.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest
import CoreLocation
@testable import BankUI

class LoadAtmsFromRealm: XCTestCase {
    
    var sut: ATMListInteractorProtocol!

    override func setUp() {
        sut = ATMListInteractor(presenter: ATMListPresenter(view: ATMListVC()))
    }

    override func tearDown() {
        sut = nil
    }

    
    func testAtmsOrdered() {
        let isEmpty = sut.checkDataInRealm()
        if !isEmpty {
            let result = sut.loadAtmsListFromRealm(with: [(true, 1)], with: 5, withLocation: CLLocation(latitude: 55.695811, longitude: 37.662665))
            
            XCTAssertTrue(result.count > 0)
            
            for i in 1..<result.count {
                XCTAssertTrue(result[i-1].distanceToCurrentUser < result[i].distanceToCurrentUser, "Массив должен быть отсортирован по полю distanceToCurrentUser по возрастанию")
            }
        }
    }
    
    func testAtmsNotOrdered() {
        let isEmpty = sut.checkDataInRealm()
        if !isEmpty {
            let result = sut.loadAtmsListFromRealm(with: [(true, 1)], with: 5, withLocation: CLLocation(latitude: 55.695811, longitude: 37.662665))
            
            XCTAssertTrue(result.count > 0)
            
            for i in 1..<result.count {
                XCTAssertFalse(result[i-1].distanceToCurrentUser > result[i].distanceToCurrentUser, "Массив должен быть отсортирован по полю distanceToCurrentUser по возрастанию")
            }
        }
    }
}

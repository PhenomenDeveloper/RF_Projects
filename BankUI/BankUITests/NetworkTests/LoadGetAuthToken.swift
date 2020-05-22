//
//  LoadGetAuthToken.swift
//  BankUITests
//
//  Created by KOLESNIKOV Lev on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import XCTest
@testable import BankUI

class LoadGetAuthToken: XCTestCase {
    
    var networkServiceSut: NetworkService!
    var dataFetcherSut: NetworkDataFetcher!

    override func setUp() {
        networkServiceSut = NetworkService()
        dataFetcherSut = NetworkDataFetcher(networking: networkServiceSut)
    }

    override func tearDown() {
        networkServiceSut = nil
    }

    func testGetAuthToken() {
        
        networkServiceSut.getNetworkUserData(path: APINetwork.auth, params: APINetwork.authParams) { (data, error) in
            XCTAssertNotNil(data, "Данные не должны быть nil")
            XCTAssertNil(error, "error должна быть nil")
        }
    }
    
    func testDecodedAuthTokenIntoModel() {
        
        dataFetcherSut.getNetworkUserData(completion: { (userData) in
            XCTAssertNotNil(userData)
            let decoded = NetworkAuthModel(accessToken: userData!.accessToken, resourceOwner: userData!.resourceOwner)
            
            XCTAssertNotNil(decoded.accessToken)
            XCTAssertNotNil(decoded.resourceOwner)
            
            let userNetwork = NetworkUser(name: decoded.resourceOwner.firstName + " " + String(decoded.resourceOwner.lastName.first!) + ".",
                                          mobilePhone: decoded.resourceOwner.mobilePhone,
                                          email: decoded.resourceOwner.email)
            
            XCTAssertNotNil(userNetwork.name)
            XCTAssertNotNil(userNetwork.mobilePhone)
            XCTAssertNotNil(userNetwork.email)
            
        })
    }


}

//
//  APINetwork.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

enum ATMDataType: String, CaseIterable {
    case points
    case subway

    var dataURL: String {
        switch self {
        case .points:
            return APINetwork.allATMPoints
        case .subway:
            return APINetwork.allSubwayPoints
        }
    }
}

struct APINetwork {

    static let scheme = "https"
    static let host = "ronline.herokuapp.com"
    static let logoHost = "online.raiffeisen.ru"
    static let auth = "/oauth/token"
    static let history = "/rest/notification/history"
    static let historyWithLogo = "/rest/card/1/transaction"
    static let allATMPoints = "/rest/geo/point"
    static let allSubwayPoints = "/rest/geo/subway"
    static let historyPage = "pageNumber"

    static let authParams = ["username": "test", "password": "test", "grant_type": "password"]
}

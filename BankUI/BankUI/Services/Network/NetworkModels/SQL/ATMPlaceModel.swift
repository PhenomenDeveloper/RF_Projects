//
//  MetroModel.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

struct ATMList: Codable {
    let list: [ATMObject]

    struct ATMObject: Codable {
        var typeId: Int
        var bankName: String
        var latitude: Double
        var longitude: Double
        var workTime: String?
        var addressFull: String?
        var subwayIds: [String]?
    }
}

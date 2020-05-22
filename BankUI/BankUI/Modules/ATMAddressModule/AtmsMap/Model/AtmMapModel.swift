//
//  AtmMapModel.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 11.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol ATMMapModelProtocol: ATMListModelProtocol, AtmLocationProtocol {
}

struct ATMMapModel: ATMMapModelProtocol {
    var typeId: Int
    var latitude: Double
    var longitude: Double
    var bankName: String
    var workTime: String?
    var addressFull: String?
    var subwayIds: [SubwaysListForAtmsModelProtocol]?
    var distanceToCurrentUser: Int
}

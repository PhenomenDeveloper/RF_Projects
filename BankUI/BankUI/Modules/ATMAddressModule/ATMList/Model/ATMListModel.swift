//
//  ATMListModel.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 21.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol ATMListModelProtocol {
    var typeId: Int { get }
    var bankName: String { get }
    var workTime: String? { get }
    var addressFull: String? { get }
    var distanceToCurrentUser: Int { get }
    var subwayIds: [SubwaysListForAtmsModelProtocol]? { get }
}

struct ATMListModel: ATMListModelProtocol {
    var typeId: Int
    var bankName: String
    var workTime: String?
    var addressFull: String?
    var subwayIds: [SubwaysListForAtmsModelProtocol]?
    var distanceToCurrentUser: Int
}

protocol SubwaysListForAtmsModelProtocol {
    var name: String { get }
    var color: String { get }
}

struct SubwaysListForAtmsModel: SubwaysListForAtmsModelProtocol {
    var name: String
    var color: String
}

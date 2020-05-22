//
//  RealmATMList.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmATMListProtocol {
    var typeId: Int { get }
    var bankName: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var workTime: String? { get }
    var addressFull: String? { get }
    var subwayIds: List<String?> { get }
}

class RealmATMList: Object, RealmATMListProtocol {
    @objc dynamic var typeId: Int = 0
    @objc dynamic var bankName: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var workTime: String? = ""
    @objc dynamic var addressFull: String? = ""
    let subwayIds = List<String?>()
}

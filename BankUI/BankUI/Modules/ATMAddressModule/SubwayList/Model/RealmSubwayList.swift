//
//  RealmSubwayList.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmSubwayListProtocol {
    var id: Int { get }
    var name: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var colour: String { get }
}

class RealmSubwayList: Object, RealmSubwayListProtocol {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var colour: String = ""
}

//
//  SubwayModel.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

struct Subway: Codable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var colour: String
}

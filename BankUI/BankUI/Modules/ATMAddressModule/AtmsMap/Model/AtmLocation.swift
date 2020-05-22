//
//  AtmLocation.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 12.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol AtmLocationProtocol {
    var latitude: Double { get }
    var longitude: Double { get }
}

struct AtmLocationModel: AtmLocationProtocol {
    var latitude: Double
    var longitude: Double
}

extension AtmLocationModel: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude.hashValue)
        hasher.combine(longitude.hashValue)
    }

    static func == (lhs: AtmLocationModel, rhs: AtmLocationModel) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

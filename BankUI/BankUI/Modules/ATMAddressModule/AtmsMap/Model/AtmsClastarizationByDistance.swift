//
//  AtmsClastarizationByDistance.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 12.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

enum AtmsClastarizationByDistance: Int {
    case tenMeters = 18
    case twentyMeteres = 17
    case fiftyMeters = 16
    case hundredMeters = 15
    case twoHundredMeters = 14
    case fiveHundredMeters = 13
    case killometers = 12
    case threeKillometers = 11
    case tenKillometers = 10
    case fiftyKillometers = 9

    ///Расстояние между класторизуемыми объектами (Измеряется в км)
    var distanceDelta: Double {
        switch self {
        case .tenMeters:
            return 0.01
        case .twentyMeteres:
            return 0.02
        case .fiftyMeters:
            return 0.05
        case .hundredMeters:
            return 0.1
        case .twoHundredMeters:
            return 0.2
        case .fiveHundredMeters:
            return 0.5
        case .killometers:
            return 1
        case .threeKillometers:
            return 3
        case .tenKillometers:
            return 10
        case .fiftyKillometers:
            return 50
        }
    }
}

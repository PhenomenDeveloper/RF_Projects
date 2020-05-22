//
//  Extension+Int.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 21.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

extension Int {
    ///Переводит градусы в радианы
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    ///Переводит радианы в градусы
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

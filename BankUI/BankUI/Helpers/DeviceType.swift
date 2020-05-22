//
//  DeviceType.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 04/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit

enum IphoneType {
    case iphone4
    case iphone5SE
    case iphone8
    case iphone8Plus
    case iphone11Pro
    case iphone11
    case iphone11ProMax
}

struct DeviceType {

    ///Возвращает модель айфона, которую использует пользователь
    /// - Returns:
    ///     Название айфона
    static func getCurrentPhoneOfUser() -> IphoneType {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                //iPhone 5 or 5S or 5C
                return .iphone5SE

            case 1334:
                //iPhone 6/6S/7/8
                return .iphone8

            case 1920, 2208:
                //iPhone 6+/6S+/7+/8+
                return .iphone8Plus

            case 2436:
                //iPhone X/XS/11 Pro
                return .iphone11Pro

            case 2688:
                //iPhone XS Max/11 Pro Max
                return .iphone11ProMax

            case 1792:
                //iPhone XR/ 11
                return .iphone11
            default:
                //iPhone 4
                return .iphone4
            }
        }
        return .iphone11ProMax
    }
}

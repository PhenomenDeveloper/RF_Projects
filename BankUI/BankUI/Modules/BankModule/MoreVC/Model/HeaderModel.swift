//
//  HeaderModel.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

struct HeaderModel {

    let backgroundGradients: [(UIColor?, UIColor?)] = [(nil, nil), (ThemeManager.Color.startGradientColorFirstHeader,
                                                      ThemeManager.Color.endGradientColorFirstHeader),
                                                     (ThemeManager.Color.startGradientColorSecondHeader,
                                                      ThemeManager.Color.endGradientColorSecondHeader),
                                                     (ThemeManager.Color.startGradientColorThirdHeader,
                                                      ThemeManager.Color.endGradientColorThirdHeader)]

    let titles: [String] = ["Адреса", "Открыть продукт", "Скидки для вас", "Баланс #всёсразу"]
    let subscriptions: [String] = ["Банкоматы и отделения", "", "", ""]
}

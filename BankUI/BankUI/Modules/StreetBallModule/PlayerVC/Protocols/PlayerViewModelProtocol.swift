//
//  PlayerViewModelProtocol.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

protocol PlayerViewModelProtocol {
    var titleArray: [Title] { get }
    var dataArray: [Datas] { get }
    var nameLabel: String { get }
    var teamLabel: String { get }

}

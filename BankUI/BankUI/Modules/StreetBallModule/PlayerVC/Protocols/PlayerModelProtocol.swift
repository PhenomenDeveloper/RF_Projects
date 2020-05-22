//
//  PlayerModelProtocol.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

protocol PlayerModelProtocol {
    func getPlayer() -> PlayerCD?
    func getTeam() -> TeamCD?
}

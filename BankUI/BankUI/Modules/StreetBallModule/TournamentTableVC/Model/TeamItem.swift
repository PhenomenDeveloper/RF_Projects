//
//  TeamItem.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

protocol TeamItemProtocol {
    var picture: String { get }
    var name: String { get }
    var winScore: Int { get }
    var loseScore: Int { get }
    var goalsScore: Int { get }
    var missedScore: Int { get }
    var teamID: String { get }
}

struct TeamItem: TeamItemProtocol {
    var picture: String
    var name: String
    var winScore: Int
    var loseScore: Int
    var goalsScore: Int
    var missedScore: Int
    var teamID: String
}

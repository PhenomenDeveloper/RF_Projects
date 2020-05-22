//
//  ViewModelProtocolTeam.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

protocol ViewModelProtocolTeam {
    var modelTeam: ModelTeam! { get }
    var player: PlayerCD? { get }
    var team: TeamCD? { get }
    var teamLabel: String { get }

}

//
//  ViewModelTeam.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation
import CoreData

class ViewModelTeam: ViewModelProtocolTeam {

    var modelTeam: ModelTeam!
    var player: PlayerCD?
    var team: TeamCD?
    var game: CalendarCD?
    var teamLabel: String = ""
    var teams: [TeamCD] = []
    var players: [PlayerCD] = []
    var games: [CalendarCD] = []

    let calendar = Calendar.current

}

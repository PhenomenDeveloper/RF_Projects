//
//  GameResultModel.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

protocol GameResultProtocol {
    var homeTeamImageName: String { get }
    var homeTeamName: String { get }
    var homeScore: Int { get }
    var guestTeamImageName: String { get }
    var guestTeamName: String { get }
    var guestScore: Int { get }
    var startDate: String { get }
    var gameStatus: String { get }
}

enum SelectedTeamType {
    case home, guest
}

enum CalendarNavigation {
    case next, previous, none
}

struct GameResult: GameResultProtocol {
    var homeTeamImageName: String

    var homeTeamName: String

    var homeScore: Int

    var guestTeamImageName: String

    var guestTeamName: String

    var guestScore: Int

    var startDate: String

    var gameStatus: String
}

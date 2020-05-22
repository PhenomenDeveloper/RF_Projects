//
//  TournamentTableVC+SortTeam.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

protocol SortTeamObjectsProtocol {
    func sortByTournamentScore(teams: inout [TeamItem])
}

// MARK: - Расширение для сортировки объектов
extension TournamentTableVC: SortTeamObjectsProtocol {

    /// Правильная сортировка таблицы команд по турнирным очкам. За победу - 2 очка, за поражение - 1 очко.
    func sortByTournamentScore(teams: inout [TeamItem]) {
        teams.sort { (item1, item2) -> Bool in

            let scorePointOne = item1.winScore * 2 + item1.loseScore * 1
            let scorePointTwo = item2.winScore * 2 + item2.loseScore * 1
            //            Сортировка по разнице в игровых очках, если одинаковое количество турнирных очков.
            if scorePointOne == scorePointTwo {
                return item1.goalsScore - item1.missedScore > item2.goalsScore - item2.missedScore
            } else {
               return scorePointOne > scorePointTwo
            }
        }
    }
}

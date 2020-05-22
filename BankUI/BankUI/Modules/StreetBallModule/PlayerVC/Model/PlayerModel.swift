//
//  PlayerModel.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation
import CoreData

class PlayerModel: PlayerModelProtocol {
    // MARK: - Свойства
    var player: PlayerCD?
    var team: TeamCD?
    var teamID: String?
    var playerID: String
    init(playerID: String) {
        self.playerID = playerID
    }
    ///Функция нахождения нужного игрока
    func getPlayer() -> PlayerCD? {
        let dataPlayer = BasketballData()
        dataPlayer.playerData()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerCD")
        do {
            let results = try CoreDataManager.sharedInstance.context.fetch(fetchRequest) as? [PlayerCD]
            for result in results! where result.playerID  == playerID {
                player = result
            }
        } catch {
            print(error)
        }
        return player
    }
    ///Функция нахождения нужной команды
    func getTeam() -> TeamCD? {
        let dataTeam = BasketballData()
        dataTeam.teamData()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeamCD")
        do {
            let results = try CoreDataManager.sharedInstance.context.fetch(fetchRequest) as? [TeamCD]
            for result in results! where result.teamId  == teamID {
                team = result
            }
        } catch {
            print(error)
        }
        return team
    }
}

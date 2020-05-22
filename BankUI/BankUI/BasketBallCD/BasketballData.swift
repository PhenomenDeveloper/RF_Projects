//
//  BasketballData.swift
//  BankUI
//
//  Created by Виктор Корнеев on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import CoreData

class BasketballData {

    private var models = [CalendarCD]()
    private let formatter = FullDateFormatter()

    init() {
    }

    func teamData() {

        let teams = TeamDataProviderImp.shared.getTeams()
        let request = NSFetchRequest<TeamCD>.init(entityName: "TeamCD")
        let existingTeams = try? CoreDataManager.sharedInstance.context.fetch(request)
        guard let existing = existingTeams  else { return }

        if existing.count > 0 {
            return
        } else {
            for team in teams {
                let obj = TeamCD()
                obj.name = team.name
                obj.teamId = team.teamId
                obj.players = team.players as NSArray
                obj.pictures = team.picture
            }

            CoreDataManager.sharedInstance.saveContext()

        }
    }
    func playerData() {

        let players = PlayersDataProviderImp.shared.getPlayers()

        let request = NSFetchRequest<PlayerCD>.init(entityName: "PlayerCD")
        let existingPlayers = try? CoreDataManager.sharedInstance.context.fetch(request)
        guard let existing = existingPlayers  else { return }

        if existing.count > 0 {
            return
        } else {
            for player in players {
                let obj = PlayerCD()
                obj.dateBirth = player.dateBirth
                obj.hieght = Int32(player.hieght)
                obj.name = player.name
                obj.number = Int32(player.number)
                obj.playerID = player.playerID
                obj.position = player.position
                obj.surName = player.surName
                obj.teamID = player.teamID
                obj.titul = player.titul
                obj.weight = Int32(player.weight)
            }
            CoreDataManager.sharedInstance.saveContext()
        }
    }

    /// Получение даты начала игрового сезона и его завершения
    ///
    /// - Returns:
    ///     Возвращает кортеж.
    ///     Где .0 - дата начала игрового сезона.
    ///     Где .1 - дата завершения игрового сезона.
    private func getStartAndEndDate() -> (Date, Date)? {

        let calendar = Calendar.current
        let currentDate = Date()
        let startDate = formatter.date(from: "2019-10-01-15:00")

        guard let start = startDate else { return nil }
        guard let dateInterval = calendar.dateInterval(of: .year, for: currentDate) else { return nil }

        return (start, dateInterval.end)
    }

    func getGames(startDate: Date, endDate: Date) -> [CalendarCD] {
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
      return self.models.filter {

        if let startdDate = $0.startdDate, let endDate = $0.endDate {
            return (startdDate >= startDate) && (endDate <= endDate)
        }
        return false
      }
     }

    func calendarData() {

        let gamesDate = getStartAndEndDate()
        guard let date = gamesDate else { return }

        let calendar = CalendarDataProviderImp.shared.getGames(startDate: date.0, endDate: date.1)
        let request = NSFetchRequest<CalendarCD>.init(entityName: "CalendarCD")
        let existingPlayers = try? CoreDataManager.sharedInstance.context.fetch(request)
        guard let existing = existingPlayers  else { return }

        if existing.count > 0 {
            return
        } else {
            for dates in calendar {
                let obj = CalendarCD()
                if let date = dates.endDate {
                    obj.endDate = date
                }
                obj.guestScore = Int32(dates.guestScore)
                obj.guestTeam = dates.guestTeam
                obj.homeScore = Int32(dates.homeScore)
                obj.homeTeam = dates.homeTeam
                obj.startdDate = dates.startDate
            }
            CoreDataManager.sharedInstance.saveContext()
        }
    }

    func getCalendarGames(startDate: Date, endDate: Date) -> [CalendarCD] {

        let request = NSFetchRequest<CalendarCD>.init(entityName: "CalendarCD")
        let predicate = NSPredicate(format: "startdDate > %@", startDate as NSDate)
        let orderDate = NSSortDescriptor(key: "startdDate", ascending: true)
        request.predicate = predicate
        request.sortDescriptors = [orderDate]
        if let calendarGames = try? CoreDataManager.sharedInstance.context.fetch(request) {
            return calendarGames
        }
        return []
    }
}

//
//  CalendarInteractor.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation
import CoreData

protocol CalendarInteractorProtocol: class {

    func getGameResultInfo() -> [CalendarCD]
    func getNextDateGame(from date: Date) -> [CalendarCD]
    func getPreviousDateGameResult(from date: Date) -> [CalendarCD]
    func getTeamsInfoForNearestGames(games: [CalendarCD]) -> [TeamCD]
}

class CalendarInteractor {

    // MARK: - Свойства

    weak var presenter: CalendarPresenterProtocol!

    ///Начальная дата в json для календаря
    private lazy var startCalendarDate: Date = {
        let formatter = FullDateFormatter()
        guard let date = formatter.date(from: "2020-01-14-15:00") else {return Date()}
        return date
    }()

    ///Конечная дата в json для календаря
    private lazy var endCalendarDate: Date = {
        let formatter = FullDateFormatter()
        guard let date = formatter.date(from: "2020-12-29-17:21") else {return Date()}
        return date
    }()

    ///Календарь с текущей тайм зоной
    private var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar
    }()

    required init(presenter: CalendarPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Вспомогательные функции

    ///Находит список игр которые проводятся в указанную дату, либо в ближайшую дату в будушем
    ///
    /// - Parameters:
    ///     - fromDate: Стартовое время для искомого дня (00:00:00)
    ///     - toDate: Конечное время для искомого дня (23:59:59)
    /// - Returns:
    ///     Список игр которые проводятся в переданную дату или в ближайшую к ней
    private func getCalendarInfo(from fromDate: Date, to toDate: Date) -> [CalendarCD] {

        if fromDate < endCalendarDate {
            //Получаем игры начиная с текущего дня
            let todayGames = CoreDataManager.sharedInstance.getGames(startDate: fromDate, endDate: toDate)

            //Получаем игры для текущего дня
            return getCurrentDayGames(calendarInfo: todayGames)
        } else {
            return []
        }
    }

    ///Возвращает интервал текущего дня начиная с 00:00:00 и до 23:59:59
    /// - Parameters:
    ///     - date: Дата относительно которой идет подсчет
    ///     - navigationType: Навигация по календарю. Либо подсчитываем сутки для следующего дня, либо для предыдущего
    /// - Returns:
    ///     Возвращаемое значение
    private func getDayInterval(from date: Date = Date(), navigationType: CalendarNavigation = .none) -> DateInterval {

        var startDay: Date
        var components = DateComponents()

        switch navigationType {
        //Следующая дата календаря
        case .next:
            components.day = 1
            guard let startCurrentDay = calendar.date(byAdding: components, to: date) else {
                return DateInterval(start: date, end: Date())
            }
            startDay = calendar.startOfDay(for: startCurrentDay)
        //Предудыщая дата колендаря
        case .previous:
            components.day = -1
            guard let startCurrentDay = calendar.date(byAdding: components, to: date) else {
                return DateInterval(start: date, end: Date())
            }
            startDay = calendar.startOfDay(for: startCurrentDay)
        //Текущая дата календаря
        case .none:
            //Начало текущего дня
            startDay = calendar.startOfDay(for: date)
        }

        components.day = 1
        // Настройка конца дня, как -1 секунду от конца текущего дня
        components.second = -1
        guard let endCurrentDay = calendar.date(byAdding: components, to: startDay) else {
            return DateInterval(start: startDay, end: Date())
        }

        let currentDayInterval = DateInterval(start: startDay, end: endCurrentDay)
        return currentDayInterval
    }

    ///Возвращает список игр которые проводятся в текущий день
    ///
    /// - Parameters:
    ///     - calendarInfo: Расписание игр
    /// - Returns:
    ///     Список игр текущего дня
    private func getCurrentDayGames(calendarInfo: [CalendarCD]) -> [CalendarCD] {

        //Получаем ближайшую игру к сегодняшнему дню
        guard let nearestGame = calendarInfo.first else {return []}
        //Получаем ее день
        let day = calendar.component(.day, from: nearestGame.startdDate!)
        var nearestGames: [CalendarCD] = []
        for game in calendarInfo {
            //Если есть игры у которых совпадает компонента дня для ближайшего, то добавляем их в массив
            if day == calendar.component(.day, from: game.startdDate!) {
                nearestGames.append(game)
            }
        }
        return nearestGames
    }
}

// MARK: - CalendarInteractorProtocol

extension CalendarInteractor: CalendarInteractorProtocol {

    ///Возвращает массив содержащий данные об играх, которые должны произойти сегодня или в ближайший день
    /// - Returns:
    ///     Возвращает массив игр
    func getGameResultInfo() -> [CalendarCD] {

        let currentDayInterval = getDayInterval()

        return getCalendarInfo(from: currentDayInterval.start, to: currentDayInterval.end)
    }

    ///Возвращает массив содержащий данные об играх, которые должны произойти в ближайшую дату от сегодняшнего дня
    ///
    /// - Parameters:
    ///     - date: Дата относительно которой идет поиск игр
    /// - Returns:
    ///     Массив найденных игр
    func getNextDateGame(from date: Date) -> [CalendarCD] {
        let nextDayInterval = getDayInterval(from: date, navigationType: .next)

        return getCalendarInfo(from: nextDayInterval.start, to: endCalendarDate)
    }

    func getPreviousDateGameResult(from date: Date) -> [CalendarCD] {
        var previousDayInterval = getDayInterval(from: date, navigationType: .previous)

        guard previousDayInterval.start > startCalendarDate else {return []}

        //Получаем игры начиная с текущего дня
        var calendarInfo = CoreDataManager.sharedInstance.getGames(startDate: previousDayInterval.start, endDate: previousDayInterval.end)
        //Получаем игры начиная текущего дня
        var nearestGames = getCurrentDayGames(calendarInfo: calendarInfo)

        //Если дата ближайшей игры больше чем дата окончания искомого дня, то ищем дальше
        while nearestGames[0].startdDate! > previousDayInterval.end {
            previousDayInterval = getDayInterval(from: previousDayInterval.start, navigationType: .previous)
            guard previousDayInterval.start > startCalendarDate else {return []}
            calendarInfo = CoreDataManager.sharedInstance.getGames(startDate: previousDayInterval.start, endDate: previousDayInterval.end)
            nearestGames = getCurrentDayGames(calendarInfo: calendarInfo)
        }

        return nearestGames
    }

    ///Возвращает данные о командах, которые играют в текущий день
    ///
    /// - Parameters:
    ///     - games: Игры назначенные на текущий день
    /// - Returns:
    ///     Данные команд играющих в текущий день
    func getTeamsInfoForNearestGames(games: [CalendarCD]) -> [TeamCD] {

        let teamsInfo: [TeamCD]? = CoreDataManager.sharedInstance.getTeams()
        var teamsForNearestGames: [TeamCD] = []

        for game in games {
            let homeTeam = teamsInfo?.first { [unowned game] (team) -> Bool in
                return team.teamId == game.homeTeam
            }
            let guestTeam = teamsInfo?.first { [unowned game] (team) -> Bool in
                return team.teamId == game.guestTeam
            }
            guard let home = homeTeam else {return []}
            teamsForNearestGames.append(home)
            guard let guest = guestTeam else {return []}
            teamsForNearestGames.append(guest)
        }
        return teamsForNearestGames
    }
}

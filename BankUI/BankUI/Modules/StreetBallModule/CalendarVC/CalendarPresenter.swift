//
//  CalendarPresenter.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

protocol CalendarPresenterProtocol: class {

    func teamSelected(with gameIndex: Int, typeSelectedTeam: SelectedTeamType)
    func getCalendarInfo(navigation: CalendarNavigation, from date: Date)
}

class CalendarPresenter {

    // MARK: - Свойства

    weak var view: CalendarVCProtocol!
    var interactor: CalendarInteractorProtocol!
    var router: CalendarRouterProtocol!

    private var nearestGames: [CalendarCD] = []
    private var teamsInfoForNearestGames: [TeamCD] = []
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        return formatter
    }()

    required init(view: CalendarVCProtocol) {
        self.view = view
    }

    // MARK: - Вспомогательные функции

    ///Собирает полученные данные из БД в модель для отображения
    /// - Returns:
    ///     Массив моделей для отображения
    private func getModelForView() -> [GameResultProtocol] {

        var gameCalendar: [GameResultProtocol] = []
        var homeTeamIndex: Int = 0
        var guestTeamIndex: Int = 1
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = .current
        for game in nearestGames {
            gameCalendar.append(GameResult(homeTeamImageName: teamsInfoForNearestGames[homeTeamIndex].pictures!,
                                           homeTeamName: teamsInfoForNearestGames[homeTeamIndex].name!,
                                           homeScore: Int(game.homeScore),
                                           guestTeamImageName: teamsInfoForNearestGames[guestTeamIndex].pictures!,
                                           guestTeamName: teamsInfoForNearestGames[guestTeamIndex].name!,
                                           guestScore: Int(game.guestScore),
                                           startDate: formatter.string(from: game.startdDate!),
                                           gameStatus: getStateOfGame(game: game)))
            homeTeamIndex += 2
            guestTeamIndex += 2
        }
        return gameCalendar
    }

    ///Рассчитывает состояние игры
    /// - Returns:
    ///     Строковое значение состояния игры
    private func getStateOfGame(game: CalendarCD) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd-HH:mm"
        formatter.calendar = Calendar(identifier: .gregorian)
        if game.startdDate! > Date() {
            return "Запланирована"
        }
        if game.endDate == nil {
            return "Идет игра"
        }
        return "Завершена"
    }
}

// MARK: - CalendarPresenterProtocol

extension CalendarPresenter: CalendarPresenterProtocol {

    ///Осуществляет поиск игр в заданный день
    ///
    /// - Parameters:
    ///     - navigation: Варианты поиска по календарю. Назад, вперед или сегодня
    ///     - date: Дата относительно которой осуществляется навигация по календарю
    func getCalendarInfo(navigation: CalendarNavigation, from date: Date) {
        let nearestGames: [CalendarCD]

        switch navigation {
        case .none:
            nearestGames = interactor.getGameResultInfo()
        case .next:
            nearestGames = interactor.getNextDateGame(from: date)
        case .previous:
            nearestGames = interactor.getPreviousDateGameResult(from: date)
        }
        if nearestGames.count == 0 {
            view.setTableView(with: [], requestFrom: navigation)
        } else {
            self.nearestGames = nearestGames
            teamsInfoForNearestGames = interactor.getTeamsInfoForNearestGames(games: nearestGames)
            let gameCalendar = getModelForView()
            view.setTableView(with: gameCalendar, requestFrom: navigation)
            guard let date = nearestGames.first?.startdDate! else { return }
            view.setCalendarView(with: dateFormatter.string(from: date))
        }
    }

    ///Пользователь выбрал команду для просмотра информации о ней
    ///
    /// - Parameters:
    ///     - gameIndex: Индекс команды в массиве данных полученных из БД
    func teamSelected(with gameIndex: Int, typeSelectedTeam: SelectedTeamType) {
        switch typeSelectedTeam {
        case .home: router.goToCommandVC(with: nearestGames[gameIndex].homeTeam!)
        case .guest: router.goToCommandVC(with: nearestGames[gameIndex].guestTeam!)
        }
    }
}

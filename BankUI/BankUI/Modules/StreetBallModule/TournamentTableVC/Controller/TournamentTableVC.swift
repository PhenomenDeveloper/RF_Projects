//
//  TournamentTableVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit
import CoreData

class TournamentTableVC: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)

    var allTeams: [TeamCD]? = []
    var teamObjects: [TeamItem] = []
    var games: [CalendarCD]!

    override func loadView() {
        super.loadView()
        setupTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        setupModel()

    }

    func getTeams() -> [TeamCD]? {

          let dataTeam = BasketballData()
          dataTeam.teamData()

          var results: [TeamCD]? = []

          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeamCD")
          do {

            results = try CoreDataManager.sharedInstance.context.fetch(fetchRequest) as? [TeamCD]
          } catch {
              print(error)
          }

        return results
    }

    /// Установка UITableView
    private func setupTableView() {

        view.addSubview(tableView)

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(TournamentTableViewCell.self, forCellReuseIdentifier: TournamentTableViewCell.reuseId)

        setupConstraints()
    }

    /// Установка Constraint для UITableView
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.setPosition(top: view.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
    }

    // MARK: - Настройка модели данных
    private func setupModel() {
        allTeams = getTeams()

        games = getAllGames()

        for i in 0..<allTeams!.count {
            let picture = allTeams![i].pictures
            let name = allTeams![i].name!
            let teamId = allTeams![i].teamId
            let winScore = getGamesWinrate(teamId: allTeams![i].teamId!).0
            let loseScore = getGamesWinrate(teamId: allTeams![i].teamId!).1
            let goalsScore = getGamesScore(teamId: allTeams![i].teamId!).0
            let missedScore = getGamesScore(teamId: allTeams![i].teamId!).1

            teamObjects.append(TeamItem(picture: picture!,
                                        name: name,
                                        winScore: winScore,
                                        loseScore: loseScore,
                                        goalsScore: goalsScore,
                                        missedScore: missedScore,
                                        teamID: teamId!))
        }

        sortByTournamentScore(teams: &teamObjects)
    }

    /// Получение всех доступных баскетбольных игр
    ///
    /// - Returns:
    ///     Возвращает массив всех доступных игр, взятых из JSON.
    private func getAllGames() -> [CalendarCD]? {

        let gamesDate = getStartAndEndDate()
        guard gamesDate != nil else { return nil }

           let dataCalendar = BasketballData()
           dataCalendar.calendarData()

           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CalendarCD")
           do {
               let results = try CoreDataManager.sharedInstance.context.fetch(fetchRequest) as? [CalendarCD]
               return results
           } catch {
               print(error)
           }
           return games
    }

    /// Получение даты начала игрового сезона и его завершения
    ///
    /// - Returns:
    ///     Возвращает кортеж.
    ///     Где .0 - дата начала игрового сезона.
    ///     Где .1 - дата завершения игрового сезона.
    private func getStartAndEndDate() -> (Date, Date)? {
        let formatter = FullDateFormatter()
        let calendar = Calendar.current
        let currentDate = Date()
        let startDate = formatter.date(from: "2019-10-01-15:00")

        guard let start = startDate else { return nil }
        guard let dateInterval = calendar.dateInterval(of: .year, for: currentDate) else { return nil }

        return (start, dateInterval.end)
    }

    /// Получение текущего игрового счета для команды
    ///
    /// - Returns:
    ///     Возвращает кортеж.
    ///     Где .0 - количество набранных очков.
    ///     Где .1 - количество пропущенных очков.
    private func getGamesScore(teamId: String) -> (Int, Int) {
        let homeGamesScore = games.filter {$0.homeTeam == teamId}
            .map {$0.homeScore}
            .reduce(0, +)

        let guestGamesScore = games.filter {$0.guestTeam == teamId}
            .map {$0.guestScore}
            .reduce(0, +)

        return (Int(homeGamesScore), Int(guestGamesScore))
    }

    /// Получение текущего игрового счета для команды
    ///
    /// - Returns:
    ///     Возвращает кортеж.
    ///     Где .0 - количество побед команды.
    ///     Где .1 - количество поражений команды.
    private func getGamesWinrate(teamId: String) -> (Int, Int) {
        let winScore = games.filter {$0.homeTeam == teamId}
            .filter {$0.homeScore > $0.guestScore}.count

        let loseScore = games.filter {$0.homeTeam == teamId}
            .filter {$0.homeScore < $0.guestScore}.count

        return (winScore, loseScore)
    }
}

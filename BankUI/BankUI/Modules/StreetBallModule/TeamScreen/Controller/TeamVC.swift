//
//  TeamVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit
import EventKit

class TeamVC: UIViewController, UITableViewDelegate {
    var teamID: String!
    var viewModelTeam: ViewModelProtocolTeam!
    var gamesInVC: [CalendarCD] = []
    var teamsInVC: [TeamCD] = []
    var playersInVC: [PlayerCD] = []
    var playersForDisplay: [PlayerCD] = []
    let model = ModelTeam()
    var homeTeamName = String()
    var guestTeamName = String()
    let assembly = TeamAssembly()
    var directionXAnchor: CGFloat = 500.0
    let playersArray1 = ["yarjar", "4fs9isjwj3", "bgambbfgs", "fraftnds"]
    let playersArray2 = [ "vthzht63j", "gazvkaz", "dwade", "andrbir"]
    let tableView = UITableView(frame: .zero, style: .plain)
    let calendar = Calendar.current
    let teamMembersLabel: UILabel = {
        let label = UILabel()
        label.text = "Состав:"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    let teamInsignia = TeamInsignia()
    let eventStore = EKEventStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.tableView.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        assembly.configureView(with: self)
        setupTeamInsignia()
        setupTeamMembersLabel()
        setupTableView()
        setData()
        printTeams(testTeamId: teamID)
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить в календарь", style: .plain, target: self, action: #selector(addToCalendarTaped))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.939917624, green: 0.7846449018, blue: 0, alpha: 1)
        navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.939917624, green: 0.7846449018, blue: 0, alpha: 1)
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            directionXAnchor = -500.0
            playersForDisplay = []
            for i in 0..<playersArray1.count {
                for player in playersInVC where player.playerID == playersArray1[i] {
                    playersForDisplay.append(player)
                }
            }
            playersForDisplay = playersForDisplay.sorted { (player1, player2) -> Bool in
                return player1.number < player2.number
            }
            self.tableView.reloadData()
        } else if gesture.direction == .left {
            directionXAnchor = 500.0
            playersForDisplay = []
            for i in 0..<playersArray2.count {
                for player in playersInVC where player.playerID == playersArray2[i] {
                    playersForDisplay.append(player)
                }
            }
            playersForDisplay = playersForDisplay.sorted { (player1, player2) -> Bool in
                return player1.number < player2.number
            }
            self.tableView.reloadData()
        }
    }
    @objc func addToCalendarTaped() {
        for game in gamesInVC {
            removeEvent(store: eventStore, start: game.startdDate!)
        }
        getGames(testTeamId: teamID)
    }
    func teamsToVC() -> [TeamCD] {
        let teamsRequest = CoreDataManager.sharedInstance.getTeams()
        guard let teams = teamsRequest else { return [] }
        return teams
    }
    func playersToVC() -> [PlayerCD] {
        let playersRequest = CoreDataManager.sharedInstance.getPlayers()
        guard let players = playersRequest else { return [] }
        return players
    }
    func gamesToVC() -> [CalendarCD] {
        let gamesRequest = CoreDataManager.sharedInstance.getGames()
        guard let games = gamesRequest else { return [] }
        return games
    }
    func setData() {
        gamesInVC = gamesToVC()
        playersInVC = playersToVC()
        teamsInVC = teamsToVC()
    }
    ///Добавление в календарь
    ///
    /// - Parameters:
    ///     -  store: доступ к данным календаря и напоминаний
    ///     -  startDate: начальная дата
    ///     -  title: заголовок события
    func insertEvent(store: EKEventStore, startDate: Date, title: String) {
        let calendars = store.calendars(for: .event)
        for calendar in calendars where calendar.title == "streetball" {
            let endDate = startDate.addingTimeInterval(60 * 60)
            let event = EKEvent(eventStore: store)
            event.calendar = calendar
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            do {
                try store.save(event, span: .thisEvent)
            } catch {
                print("Error saving event in calendar")             }
        }
    }
    func getGames(testTeamId: String) {
        for game in gamesInVC {
            if game.homeTeam == testTeamId {
                for teamInVC in teamsInVC {
                    if teamInVC.teamId == game.guestTeam {
                        guestTeamName = teamInVC.name!
                    }
                    if teamInVC.teamId == game.homeTeam {
                        homeTeamName = teamInVC.name!
                    }
                }
                switch EKEventStore.authorizationStatus(for: .event) {
                case .authorized:
                    insertEvent(store: eventStore, startDate: game.startdDate!, title: "\(homeTeamName) - \(guestTeamName)")
                case .denied:
                    print("Access denied")
                case .notDetermined:
                    eventStore.requestAccess(to: .event, completion: {[weak self] (granted: Bool, _: Error?) -> Void in
                        if granted {
                            self!.insertEvent(store: self!.eventStore, startDate: game.startdDate!, title: "\(self!.homeTeamName) - \(self!.guestTeamName)")
                        } else {
                            print("Access denied")
                        }
                    })
                default:
                    print("Case default")
                }
            } else if game.guestTeam == testTeamId {
                for teamInVC in teamsInVC {
                    if teamInVC.teamId == game.guestTeam {
                        guestTeamName = teamInVC.name!
                    }
                    if teamInVC.teamId == game.homeTeam {
                        homeTeamName = teamInVC.name!
                    }
                }
                switch EKEventStore.authorizationStatus(for: .event) {
                case .authorized:
                    insertEvent(store: eventStore, startDate: game.startdDate!, title: "\(homeTeamName) - \(guestTeamName)")
                case .denied:
                    print("Access denied")
                case .notDetermined:
                    eventStore.requestAccess(to: .event, completion: {[weak self] (granted: Bool, _: Error?) -> Void in
                        if granted {
                            self!.insertEvent(store: self!.eventStore, startDate: game.startdDate!, title: "\(self!.homeTeamName) - \(self!.guestTeamName)")
                        } else {
                            print("Access denied")
                        }
                    })
                default:
                    print("Case default")
                }
            }
        }
    }
    private func removeEvent(store: EKEventStore, start: Date) {
        let calendars = store.calendars(for: .event)
        for calendar in calendars where calendar.title == "streetball" {
            let startDate = start
            let endDate = startDate.addingTimeInterval(60 * 60)
            let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            let events = store.events(matching: predicate) as [EKEvent]?
            if events != nil {
                for event in events! {
                    do {
                        (try store.remove(event, span: EKSpan.thisEvent, commit: true))
                    } catch let error {
                        print("Error removing events: ", error)
                    }
                }
            }
        }
    }
    var playersNumber = [String]()
    var k = 0
    var intArray = [Int]()
    var playersINeed = [String]()
    var teamName = String()
    /// Отображение игроков нужной команды
    func printTeams(testTeamId: String) {
        for team in teamsInVC where team.teamId == testTeamId {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: team.name, style: .plain, target: nil, action: nil)
            teamInsignia.teamNameLabel.text = team.name
            teamInsignia.teamLogo.image = UIImage(named: (team.pictures!))
            for player in playersInVC where player.teamID == testTeamId {
                playersForDisplay.append(player)
            }
            playersForDisplay = playersForDisplay.sorted { (player1, player2) -> Bool in
                return player1.number < player2.number
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fabrica = Fabrica()
        let view = fabrica.getVC(id: playersForDisplay[indexPath.row].playerID!)
        navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, directionXAnchor, 0, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    // MARK: - Constraints
    /// Установка Constraint для UITableView
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        view.addSubview(tableView)
        tableView.register(CustomTableViewCellForTeam.self, forCellReuseIdentifier: TournamentTableViewCell.reuseId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setPosition(top: self.teamMembersLabel.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 10,
                              paddingLeft: 10,
                              paddingBottom: 0,
                              paddingRight: 10,
                              width: 0,
                              height: 0)
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    /// Constraints для view на которой логотип команды и ее название
    func setupTeamInsignia() {
        self.view.addSubview(teamInsignia)
        teamInsignia.translatesAutoresizingMaskIntoConstraints = false
        teamInsignia.setPosition(top: self.view.safeAreaLayoutGuide.topAnchor,
                                 left: self.view.leftAnchor,
                                 bottom: nil,
                                 right: self.view.rightAnchor,
                                 paddingTop: 10,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 0,
                                 width: 0,
                                 height: 0)
    }
    /// Констрейнты для лейбла "Состав:"
    func setupTeamMembersLabel() {
        self.view.addSubview(teamMembersLabel)
        teamMembersLabel.translatesAutoresizingMaskIntoConstraints = false
        teamMembersLabel.setPosition(top: self.teamInsignia.bottomAnchor,
                                     left: self.view.leftAnchor,
                                     bottom: nil,
                                     right: self.view.rightAnchor,
                                     paddingTop: 30,
                                     paddingLeft: 30,
                                     paddingBottom: 10,
                                     paddingRight: 30,
                                     width: 0,
                                     height: 0)
        teamMembersLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}

// MARK: - Data Source Extension
extension TeamVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersForDisplay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCellForTeam.reuseId, for: indexPath) as? CustomTableViewCellForTeam else { return UITableViewCell() }
        cell.playerNumberLabel.text = "\(playersForDisplay[indexPath.row].number):"
        cell.playerSurnameLabel.text = "\(playersForDisplay[indexPath.row].surName ?? "")"
        cell.playerNameLabel.text = "\(playersForDisplay[indexPath.row].name ?? "")"
        cell.accessoryType = .disclosureIndicator
        cell.accessibilityIdentifier = "TeamCell"
        return cell
    }
}

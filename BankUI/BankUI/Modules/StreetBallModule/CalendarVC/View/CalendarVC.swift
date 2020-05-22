//
//  CalendarVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

protocol CalendarVCProtocol: UIViewController {

    func nextDateClicked()
    func previousDateClicked()
    func setTableView(with value: [GameResultProtocol], requestFrom: CalendarNavigation)
    func setCalendarView(with date: String)
}

private let cellIdentifier = "CalendarCell"

class CalendarVC: UIViewController {

    // MARK: - Свойства

    var configurator: CalendarConfiguratorProtocol = CalendarConfigurator()
    var presenter: CalendarPresenterProtocol!
    var gameCalendar: [GameResultProtocol] = []

    ///Форматер для даты в шапке экрана
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        return formatter
    }()

    ///Контейнер перехода между датами календаря
    let dateView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    ///Кнопка перехода на предыдущую дату
    lazy var previousButton: UIButton = {
        let button = UIButton(type: .system)

        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        return button
    }()

    ///Кнопка перехода на следующую дату
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)

        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()

    ///Просматриваемая дата
    let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    var tableView: UITableView!

    // MARK: - Инициализаторы

    override func loadView() {
        super.loadView()

        tableView = UITableView()
        configureViewComponents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CalendarCell.self, forCellReuseIdentifier: cellIdentifier)

        configurator.configureView(with: self)
        presenter.getCalendarInfo(navigation: .none, from: Date())
    }

    // MARK: - Настройка внешнего вида

    func configureViewComponents() {
        //Добавляем контейнер навигации по календарю
        self.view.addSubview(dateView)
        dateView.setPosition(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)

        //Предудыщуая дата
        dateView.addSubview(previousButton)
        previousButton.setPosition(top: nil, left: dateView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        previousButton.centerYAnchor.constraint(equalTo: dateView.centerYAnchor).isActive = true

        //Следующая дата
        dateView.addSubview(nextButton)
        nextButton.setPosition(top: nil, left: nil, bottom: nil, right: dateView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        nextButton.centerYAnchor.constraint(equalTo: dateView.centerYAnchor).isActive = true

        dateView.addSubview(dateLabel)
        dateLabel.centerXAnchor.constraint(equalTo: dateView.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: dateView.centerYAnchor).isActive = true
        dateLabel.text = dateFormatter.string(from: Date())

        //Таблица
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.setPosition(top: dateView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    }

    // MARK: - Обработка нажатия кнопок

    @objc private func nextButtonTapped() {
        nextDateClicked()
    }

    @objc private func previousButtonTapped() {
        previousDateClicked()
    }

    // MARK: - Вспомогательные функции

    private func showAlertController(message: String) {
        let alertVC = UIAlertController(title: "Календарь", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource UITableViewDelegate
extension CalendarVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameCalendar.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CalendarCell else { return UITableViewCell()}

        cell.index = indexPath.row
        cell.delegate = self

        cell.homeImageTeam.image = UIImage(named: gameCalendar[indexPath.row].homeTeamImageName)
        cell.guestImageTeam.image = UIImage(named: gameCalendar[indexPath.row].guestTeamImageName)
        cell.homeTeamNameLabel.text = gameCalendar[indexPath.row].homeTeamName
        cell.guestTeamNameLabel.text = gameCalendar[indexPath.row].guestTeamName
        cell.homeScoreLabel.text = "\(gameCalendar[indexPath.row].homeScore)"
        cell.guestScoreLabel.text = "\(gameCalendar[indexPath.row].guestScore)"
        cell.matchTimeLabel.text = gameCalendar[indexPath.row].startDate
        cell.stateOfGameLabel.text = gameCalendar[indexPath.row].gameStatus

        cell.accessibilityIdentifier = "CalendarCell"

        return cell
    }
}

// MARK: - CalendarVCProtocol
extension CalendarVC: CalendarVCProtocol {

    func nextDateClicked() {
        //передаем дату из dateLabel
        guard let date = dateFormatter.date(from: dateLabel.text!) else { return }
        presenter.getCalendarInfo(navigation: .next, from: date)
    }

    func previousDateClicked() {
        guard let date = dateFormatter.date(from: dateLabel.text!) else { return }
        presenter.getCalendarInfo(navigation: .previous, from: date)
    }

    func setTableView(with calendar: [GameResultProtocol], requestFrom: CalendarNavigation) {
        if calendar.count > 0 {
            gameCalendar = calendar
            tableView.reloadData()
        } else {
            switch requestFrom {
            case .next: showAlertController(message: "Больше нет запланированных игр")
            case .previous: showAlertController(message: "Вы находитесь в начале календаря для текущего сезона")
            default: break
            }
        }
    }

    func setCalendarView(with date: String) {
        dateLabel.text = date
    }
}

// MARK: - CalendarCellProtocol
extension CalendarVC: CalendarCellProtocol {

    func homeTeamImageClicked(with cellIndex: Int) {
        presenter.teamSelected(with: cellIndex, typeSelectedTeam: .home)
    }

    func guestTeamImageClicked(with cellIndex: Int) {
        presenter.teamSelected(with: cellIndex, typeSelectedTeam: .guest)
    }
}

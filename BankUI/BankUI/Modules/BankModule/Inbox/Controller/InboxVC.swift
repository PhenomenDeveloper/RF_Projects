//
//  InboxVC.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class InboxVС: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)
    private var pageCount = 0
    private var totalPagesCount = 1
    private var transactionsModel: [NetwrokHistoryModel] = []
    private var transactionsHistory: [Date: [NetwrokHistoryModel]] = [:]
    private var orderedDates: [Date] = []

    override func loadView() {
        super.loadView()
        setupTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        fetchHistory()
    }

    /// Установка UITableView
    private func setupTableView() {

        tableView.contentInset.top = ConstraintsManager.InboxModule.InboxTableView.topInset

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        view.addSubview(tableView)

        setupConstraints()

        tableView.register(InboxTableViewCell.self, forCellReuseIdentifier: InboxTableViewCell.reuseId)
        tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: FooterTableViewCell.reuseId)

        //Настраиваем контроль обновления ленты
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

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

    private func setupHeaderView(date: String) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear

        let title: UILabel = UILabel(frame: CGRect(x: 16, y: 4, width: tableView.frame.size.width, height: 14))

        title.font = UIFont.systemFont(ofSize: 12)
        title.text = date
        title.textColor = ThemeManager.Color.subtitleColor

        headerView.addSubview(title)

        return headerView
    }

    @objc func handleRefresh() {
        guard let baseVC = self.view.superview else {return}

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            baseVC.layer.cornerRadius = 45.0
            baseVC.frame.origin.y += 15
        }, completion: { (_) in
            UIView.animate(withDuration: 0.3) {
                baseVC.layer.cornerRadius = 8.0
                baseVC.frame.origin.y -= 15
            }
        })

        transactionsHistory = [:]
        orderedDates = []
        pageCount = 0
        totalPagesCount = 1
        fetchHistory()
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    // MARK: - Работа с сетью

    private func fetchHistory() {
        if pageCount < totalPagesCount {
            let dataFetcher = NetworkDataFetcher(networking: NetworkService())
            dataFetcher.getHistoryData(page: pageCount) {[unowned self] (model) in
                guard let model = model else {
                    print("Ошибка получения данных транзакции")
                    return
                }
                self.totalPagesCount = model.totalPages
                self.transactionsModel = []
                //            let uniqueTransaction = self.getUniqueElements(from: model.content)
                for content in model.content {
                    self.transactionsModel.append(NetwrokHistoryModel(sendAt: content.sendAt, title: content.title, body: content.body, transactionDate: content.params.transactionDate))
                }
                self.orderTransactionByDate()
                self.pageCount += 1
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Вспомогательные функции

    ///Возвращает массив уникальных элементов
    ///
    /// - Parameters:
    ///     - array: Массив с повторяющимися элементами
    /// - Returns:
    ///     Возвращает массив без повторяющихся элементов
    private func getUniqueElements<T: Equatable>(from array: [T]) -> [T] {
        var unique = [T]()
        for item in array {
            if !unique.contains(item) {
                unique.append(item)
            }
        }
        return unique
    }

    private func orderTransactionByDate() {
        // 1. Сортировать по дате
        var calendar: Calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!

        //Заполняем уникальными датами
        for transaction in transactionsModel {
            let date: Date? = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: transaction.sendAt))
            transactionsHistory[date!] = []
        }
        self.orderedDates = transactionsHistory.keys.sorted(by: >)

        //Каждой дате ставим в соответствие транзакцию
        for transaction in transactionsModel {
            let date: Date? = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: transaction.sendAt))
            transactionsHistory[date!]?.append(transaction)
        }
    }
}

// MARK: - Data Source Extension
extension InboxVС: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let key = orderedDates[section]
        if section == transactionsHistory.keys.count - 1 {
            return transactionsHistory[key]!.count + 1
        }
        return transactionsHistory[key]!.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsHistory.keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: InboxTableViewCell.reuseId, for: indexPath) as? InboxTableViewCell else { return UITableViewCell() }

        if let values = transactionsHistory[orderedDates[indexPath.section]] {

            //Для footer
            if indexPath.section == transactionsHistory.keys.count - 1 && indexPath.row == values.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.reuseId, for: indexPath) as? FooterTableViewCell else { return UITableViewCell() }
                return cell
            }

            //Для обычных ячеек
            cell.statement = values[indexPath.row]
        }
        cell.accessibilityIdentifier = "InboxCell"
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dateFormatter: DateFormatter = DateFormatter.transactionsDataFormat
        return setupHeaderView(date: dateFormatter.string(from: orderedDates[section]))
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  indexPath.section == orderedDates.count - 1 && indexPath.row == transactionsHistory[orderedDates[indexPath.section]]!.count - 1 {
            fetchHistory()
        }
    }
}

extension InboxVС: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
}

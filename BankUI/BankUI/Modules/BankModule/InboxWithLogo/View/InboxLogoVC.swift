//
//  InboxLogoVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit
import RealmSwift

protocol InboxLogoVCProtocol: class {

}

class InboxLogoVC: UIViewController {

    // MARK: - Свойства

    var prevTitle: String?

    var containerView: UIView = UIView()

    var configurator: InboxLogoConfiguratorProtocol = InboxLogoConfigurator()
    var presenter: InboxLogoPresenterProtocol!

    private var direction: NavigationTitleAnimationDirection = .left

    var additionalInfo = ""
    var selectedIndexPath: IndexPath?
    var previousIndexPath: IndexPath?

    // MARK: - UI свойства
    ///Таблица для отображения списка транзакций
    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: - Инициализация View

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContainerView(container: containerView, containerColor: ThemeManager.Color.backgroundColor)

        setupTableView()
        setupSpinner()
        configurator.configureView(with: self)
        loadTransactions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let navController = navigationController else { return }
        addNavigationControllerTitleAnimation(navVC: navController,
                                              nextTitle: "История", direction: direction)
    }

    /// Установка UITableView
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        setupConstraints()

        tableView.contentInset.top = ConstraintsManager.InboxModule.InboxTableView.topInset
        //Без этой строчки, когда таблица загружается из БД, контент располагался не так как нужно (Слишком близко к началу таблицы)
        tableView.contentOffset = CGPoint(x: 0, y: -ConstraintsManager.InboxModule.InboxTableView.topInset)

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        tableView.register(InboxWithLogoTableViewCell.self, forCellReuseIdentifier: InboxWithLogoTableViewCell.reuseId)
        tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: FooterTableViewCell.reuseId)

        //Настраиваем контроль обновления ленты
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

    }

    ///Устанавливает спинер
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }

    /// Установка Constraint для UITableView
    private func setupConstraints() {

        tableView.fillToSuperView(view: view)
    }

    ///Устанавливает заголовок секции
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

    // MARK: - Работа с БД

    ///Загружает данные о транзакциях
    private func loadTransactions() {
        spinner.startAnimating()
        presenter.getTransactions {
            OperationQueue.main.addOperation {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

    ///Обновление данных таблицы путем pull to refresh
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

        loadTransactions()
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    // MARK: - Вспомогательные функции

    ///Устанавливает данные в соответствующую ячейку
    ///
    /// - Parameters:
    ///     - cell: Ячейка в которую устанавливаются данные
    ///     - transaction: Данные транзакции которые необходимо установить в ячейку
    private func setInboxLogoCell(with cell: InboxWithLogoTableViewCell, with transaction: RealmTransactionProtocol, indexPath: IndexPath) {
        //        print(transaction)
        cell.operationTypeLabel.text = "Операция по карте \(transaction.secureCardNumber)"

        if indexPath == selectedIndexPath {
            additionalInfo = "\n\nЗдесь могла быть ваша реклама"

        } else {
            additionalInfo = ""
        }
        if let site = transaction.site {
            cell.nameLabel.text = "\(transaction.merchant)\nСайт - \(site)\nСумма: \(transaction.amount) \(transaction.currencySymbol)" + additionalInfo

        } else {
            cell.nameLabel.text = "\(transaction.merchant)\nСумма: \(transaction.amount) \(transaction.currencySymbol)" + additionalInfo
        }
        cell.logoImage.image = #imageLiteral(resourceName: "money")

        guard let merchantLogoId = transaction.merchantLogoId else { return }

        presenter.getPhotoImage(with: merchantLogoId) { (image) in
            DispatchQueue.main.async {
                cell.logoImage.image = image
            }
        }
    }
}

extension InboxLogoVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch selectedIndexPath {
        case nil:
            selectedIndexPath = indexPath

        default:
            if selectedIndexPath == indexPath {
                selectedIndexPath = nil
            } else {
                selectedIndexPath = indexPath
            }
        }
        if previousIndexPath == nil {

            tableView.performBatchUpdates({
                if let index = previousIndexPath {
                    self.tableView.reloadRows(at: [indexPath, index], with: .automatic)
                } else {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                previousIndexPath = indexPath
            }, completion: nil)

        } else {
            tableView.performBatchUpdates({
                self.tableView.reloadRows(at: [indexPath, previousIndexPath!], with: .automatic)
                previousIndexPath = indexPath
            }, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let key = presenter.getOrderedDate(at: section)
        if section == presenter.getTransactionsKeysCount() - 1 {
            return presenter.getTransactionsCount(forKey: key) + 1
        }
        return presenter.getTransactionsCount(forKey: key)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getTransactionsKeysCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: InboxWithLogoTableViewCell.reuseId, for: indexPath) as? InboxWithLogoTableViewCell else { return UITableViewCell() }

        let transactions = presenter.getTransactions(forKey: presenter.getOrderedDate(at: indexPath.section))

        //Для футера
        if indexPath.section == presenter.getTransactionsKeysCount() - 1 && indexPath.row == transactions.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.reuseId, for: indexPath) as? FooterTableViewCell else { return UITableViewCell() }
            return cell
        }

        //Для обычных ячеек
        setInboxLogoCell(with: cell, with: transactions[indexPath.row], indexPath: indexPath)

        cell.accessibilityIdentifier = "InboxWithLogoCell"

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return setupHeaderView(date: dateFormatter.string(from: presenter.getOrderedDate(at: section)))
    }
}

extension InboxLogoVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
}

extension InboxLogoVC: InboxLogoVCProtocol {

}

extension InboxLogoVC: AnimationDirectionProtocol {

    func setDirection(direction: NavigationTitleAnimationDirection) {
        self.direction = direction
    }
}

extension InboxLogoVC: SetupContainerViewProtocol {
    func setupContainerView(container: UIView, containerColor: UIColor) {
         containerView.backgroundColor = containerColor
         containerView.translatesAutoresizingMaskIntoConstraints = false

         view.addSubview(containerView)
        containerView.setPosition(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
         containerView.roundCorners(cornerRadius: ThemeManager.Corner.containerViewCornerRadius)
     }
}

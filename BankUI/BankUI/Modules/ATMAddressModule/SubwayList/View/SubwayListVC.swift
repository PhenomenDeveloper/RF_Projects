//
//  SubwayListVC.swift
//  TableView
//
//  Created by MANVELYAN Gevorg on 16.01.2020.
//  Copyright © 2020 MANVELYAN Gevorg. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit
import CoreLocation

protocol SubwayListVCProtocol: UIViewController {
    func getParentNavigationVC() -> UINavigationController?
}

class SubwayListVC: UIViewController {

    // MARK: - Свойства

    var configurator: SubwayListConfiguratorProtocol = SubwayListConfigurator()
    var presenter: SubwayListPresenterProtocol?

    let tableView = UITableView(frame: .zero, style: .grouped)

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private let warningLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private var isSpinnerHidden = false

    // MARK: - Настройка UI

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9529617429, green: 0.9528346658, blue: 0.9614482522, alpha: 1)

        setupTableView()
        setupWarningLabel()
        setupSpinner()
        configurator.configureView(with: self)
    }

    /// Установка UITableView
    private func setupTableView() {

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)

        //Настраиваем контроль обновления ленты
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)

        setupConstraints()

        tableView.register(SubwayListTableviewCell.self, forCellReuseIdentifier: SubwayListTableviewCell.reuseId)
    }

    ///Устанавливает заголовок секции
     private func setupHeaderView(letter: Character) -> UIView {
         let headerView = UIView()
         headerView.backgroundColor = UIColor.clear

         let title: UILabel = UILabel(frame: CGRect(x: 16, y: 4, width: tableView.frame.size.width, height: 14))

         title.font = UIFont.systemFont(ofSize: 14, weight: .regular)
         title.text = String(letter)
         title.textColor = ThemeManager.Color.subtitleColor

         headerView.addSubview(title)

         return headerView
     }

    /// Установка Constraint для UITableView
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.setPosition(top: view.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 18,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
    }

    private func setupWarningLabel() {
        view.addSubview(warningLabel)
        warningLabel.setPosition(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.setPosition(top: nil, left: nil, bottom: warningLabel.topAnchor, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    }

    // MARK: - Работа с данными

    ///Устанавливает данные в соответствующую ячейку
    ///
    /// - Parameters:
    ///     - cell: Ячейка в которую устанавливаются данные
    ///     - subway: Данные метро которые необходимо установить в ячейку
    private func setSubwayListCell(with cell: SubwayListTableviewCell, with subway: SubwayListModelProtocol) {
        cell.metroName.text = subway.name
        cell.circle.mainColor = UIColor.init(hexString: subway.color)
        cell.numberOfATMs.text = String(subway.countOfAtms)
    }

    ///Загружает данные о метро ис БД если они есть
    func loadSubways() {
        guard let presenter = self.presenter else { return }
        //Чтобы при pull to refresh не появлялся индикатор по середине экрана, а появлялся только при загрузке данных
        if !isSpinnerHidden {
            spinner.startAnimating()
        }

        DispatchQueue.global().async {

            presenter.getSubwayList(completion: {[weak self] (result) in
                //Если записей о метро в БД столько сколько нам нужно, то выводим их на экран
                if presenter.getSubwaysCount() >= 1 {
                    OperationQueue.main.addOperation {
                        self?.warningLabel.isHidden = true
                        self?.warningLabel.text = result
                        self?.spinner.stopAnimating()
                        self?.tableView.reloadData()
                        self?.tableView.refreshControl?.endRefreshing()
                        self?.isSpinnerHidden = false
                    }
                }
                //Иначе выводит сообщение для пользователя
                else {
                    OperationQueue.main.addOperation {
                        self?.warningLabel.isHidden = false
                        self?.warningLabel.text = result
                        self?.spinner.stopAnimating()
                        self?.tableView.reloadData()
                        self?.tableView.refreshControl?.endRefreshing()
                        self?.isSpinnerHidden = false
                    }
                }
            })
        }
    }

    ///Обновление данных таблицы путем pull to refresh
    @objc func handleRefresh() {
        isSpinnerHidden = true
        loadSubways()
    }
}
// MARK: - Data Source Extension
extension SubwayListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            return 0
        }

        let key = presenter.getOrderedSubways(at: section)
        return presenter.getSubwaysCount(forKey: key)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let presenter = presenter else {
            return 0
        }

        return presenter.getSubwaysKeysCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubwayListTableviewCell.reuseId, for: indexPath) as? SubwayListTableviewCell else { return UITableViewCell() }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        guard let presenter = presenter else {
            return cell
        }

        let subwayModels = presenter.getSubwaysList(forKey: presenter.getOrderedSubways(at: indexPath.section))
        setSubwayListCell(with: cell, with: subwayModels[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let presenter = presenter else {
            return nil
        }
        return setupHeaderView(letter: presenter.getOrderedSubways(at: section))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.goToAtmsWithChoosenSubway(section: indexPath.section, index: indexPath.row)
    }
}

extension SubwayListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}

extension SubwayListVC: SubwayListVCProtocol {
    func getParentNavigationVC() -> UINavigationController? {
        return self.navigationController
    }
}

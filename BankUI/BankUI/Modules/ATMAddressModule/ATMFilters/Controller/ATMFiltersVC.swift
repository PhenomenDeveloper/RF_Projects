//
//  ViewController.swift
//  BirdBox
//
//  Created by Виктор Корнеев on 16.01.2020.
//  Copyright © 2020 Viktor Korneev. All rights reserved.
//

import UIKit

class ATMFiltersVC: UIViewController, UITableViewDelegate {

    let atmArray = ["Отделения", "Банкоматы", "Терминалы"]
    let filtersCount = 3
    var filtersValues: [Bool] = []

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()

    lazy var resetButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(tapResetButton))

        let font = UIFont.systemFont(ofSize: 14)

        button.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        button.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)

        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadFilters()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        saveFiltersInUserDefaults()
        guard let navVC = self.parent?.children.last as? ATMAdressBaseVCUpdateDataProtocol else { return }
        navVC.reloadDataForVC()
    }

    func setupNavigationBar() {
        self.navigationItem.title = "Фильтр"
        self.navigationController?.navigationBar.topItem?.title = ""

        self.navigationItem.rightBarButtonItem = resetButton

        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
    }

    func setupTableView () {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ATMFilterCell.self, forCellReuseIdentifier: ATMFilterCell.reuseId)

        view.addSubview(tableView)
        tableView.setPosition(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    }

    /// to do: Сброс всех выбранных фильтров по нажатию на кнопку
    @objc func tapResetButton() {
        for i in 0..<filtersCount {
            guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? ATMFilterCell else { return }
            cell.setDefaultFlag()
        }
    }

    private func saveFiltersInUserDefaults() {
        var flags: [Bool] = []

        for i in 0..<filtersCount {
            guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? ATMFilterCell else { return }
            flags.append(cell.getFlag())
        }

        UserData.saveFilters(filters: flags)
    }

    private func loadFilters() {
        filtersValues = UserData.getFilters()
    }
}

// MARK: - Extension Data Source
extension ATMFiltersVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ATMFilterCell.reuseId, for: indexPath) as? ATMFilterCell else { return UITableViewCell()}
        cell.filterName.text = atmArray[indexPath.row]
        cell.setFilterFlag(value: filtersValues[indexPath.row])
        cell.accessibilityIdentifier = "FilterCell"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

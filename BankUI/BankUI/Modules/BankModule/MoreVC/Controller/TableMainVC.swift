//
//  TableMainVC.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

private let cellIdentifier = "TableMainCell"

class TableMainVC: UIViewController {

    // MARK: - Свойства

//    var delegate: GoToUserSettings?
    var goToStreetBall: GoToStreetBallVC?
    var tableView: UITableView!
    let tableModel = TableMainModel()

    // MARK: - Инициализаторы

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        tableView = UITableView()

        configureViewComponents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableMainCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - Настройка внешнего вида

    func configureViewComponents() {
        tableView.alwaysBounceVertical = true
        self.view.addSubview(tableView)
        tableView.setPosition(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.separatorInset.left = 0
        tableView.separatorInset.right = 0
        //Чтобы не было сепараторов, после того как закончились ячейки
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource UITableViewDelegate
extension TableMainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.textInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableMainCell else { return UITableViewCell() }

        cell.textInfo.text = tableModel.textInfo[indexPath.row]
        cell.icon.image = UIImage(named: tableModel.iconsName[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == tableModel.iconsName.count - 1 {
            tabBarController?.selectedIndex = 2
        }
    }
}

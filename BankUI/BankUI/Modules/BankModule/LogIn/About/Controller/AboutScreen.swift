//
//  AboutScreen.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 13.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class AboutVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()

    let aboutCellId = "AboutCellId"

    let nameArray = ["Колесников Лев", "Корнеев Виктор", "Манвелян Геворг", "Омельчук Даниил"]
    let photoArray = ["KolesnikovLev", "KorneevViktor", "ManvelyanGevorg", "OmelchukDaniil"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false

        tableView.register(AboutCell.self, forCellReuseIdentifier: aboutCellId)

        view.addSubview(tableView)
        tableView.setPosition(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    func setupHeaderView(title: String) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1)

        let label: UILabel = UILabel(frame: CGRect(x: 16, y: 7, width: tableView.frame.size.width, height: 14))

        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = title
        label.textColor = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)

        headerView.addSubview(label)

        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: aboutCellId, for: indexPath) as? AboutCell else { return UITableViewCell() }
        cell.faceImageView.image = UIImage(named: photoArray[indexPath.item])
        cell.supportName.text = nameArray[indexPath.item]
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView(title: "Команда разработчиков")
    }
}

extension AboutVC: BottomCardShowProtocol {

    ///Размер отображаемой части
    var contentSize: CGFloat {
        return tableView.contentSize.height + 44
    }

    ///Закрытие контроллера
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}

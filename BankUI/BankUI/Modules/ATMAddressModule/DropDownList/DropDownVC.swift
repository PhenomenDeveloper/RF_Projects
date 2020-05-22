//
//  DropDownVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

private let cellIdentifier = "DropDownCell"

protocol SelectDropDownMenu: class {

    func select(titleName: String, navigation: NavigationAtmsAndSubways)
}

class DropDownVC: UIViewController {

    let tableView = UITableView(frame: .zero, style: .plain)

    lazy var blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
        let blurredEffectView = UIVisualEffectView(effect: blur)
        blurredEffectView.isHidden = false
        blurredEffectView.alpha = 0
        return blurredEffectView
    }()

    weak var delegate: SelectDropDownMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.register(DropDownCell.self, forCellReuseIdentifier: cellIdentifier)
        setupTableView()
    }

    /// Установка UITableView
    private func setupTableView() {

        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true

        self.view.addSubview(blurEffect)
        blurEffect.setPosition(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        self.view.addSubview(tableView)

        setupConstraints()
    }

    /// Установка Constraint для UITableView
    private func setupConstraints() {

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
}

// MARK: - Data Source Extension
extension DropDownVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DropDownCell else { return UITableViewCell()}

        if indexPath.row == 1 {
            cell.titleLabel.text = "Общий список"
        }
        if indexPath.row == 2 {

            cell.titleLabel.text = "У метро"

        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            delegate?.select(titleName: "На карте", navigation: .AtmsMap)

        } else if indexPath.row == 1 {
            delegate?.select(titleName: "Общий список", navigation: .Atms)
        } else if indexPath.row == 2 {
            delegate?.select(titleName: "У метро", navigation: .Subways)
        }
    }
}

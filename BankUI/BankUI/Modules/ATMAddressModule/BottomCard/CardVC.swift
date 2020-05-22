//
//  CardVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class CardViewVC: UIViewController {

    var atmInfo: ATMListModelProtocol?

    let tableView = UITableView(frame: .zero, style: .plain)

    let arrowImage: UIImageView = {
        let image = UIImageView()

        image.image = #imageLiteral(resourceName: "arrow")
        return image
    }()

    var interactionDismiss: BottomCardInteractiveTransition?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        tableView.register(ATMHeaderTableViewCell.self, forCellReuseIdentifier: ATMHeaderTableViewCell.reuseId)
        tableView.register(ATMAddressTableViewCell.self, forCellReuseIdentifier: ATMAddressTableViewCell.reuseId)

        tableView.register(ATMMetroStationTableViewCell.self, forCellReuseIdentifier: ATMMetroStationTableViewCell.reuseId)

        tableView.register(ATMDepartmentTableViewCell.self, forCellReuseIdentifier: ATMDepartmentTableViewCell.reuseId)

//        interactionDismiss = BottomCardInteractiveTransition(viewController: self)
    }

    /// Установка UITableView
    private func setupTableView() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero

        view.addSubview(arrowImage)
        arrowImage.setPosition(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        arrowImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(tableView)

        setupConstraints()

    }

    /// Установка Constraint для UITableView
    private func setupConstraints() {

        tableView.setPosition(top: arrowImage.bottomAnchor,
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

    private func getAtmsNameAndImage(typeId: Int) -> (UIImage?, String) {
        switch typeId {
        case 1:
            return (UIImage(named: "icDepartment"), "Отделение")
        case 3:
            return (UIImage(named: "icAtm"), "Банкомат")
        case 102:
            return (UIImage(named: "icTerminal"), "Терминал")
        default:
            return (UIImage(named: ""), "")
        }
    }

    private func setHeaderCell(for cell: ATMHeaderTableViewCell, with atmInfo: ATMListModelProtocol) -> ATMHeaderTableViewCell {
        let cellInfo = getAtmsNameAndImage(typeId: atmInfo.typeId)
        cell.logoImageView.image = cellInfo.0
        cell.titleLabel.text = cellInfo.1
        cell.distance.text = "\(atmInfo.distanceToCurrentUser) м"
        return cell
    }

    private func setSubwayInfoCell(for cell: ATMMetroStationTableViewCell, with atmInfo: ATMListModelProtocol) -> ATMMetroStationTableViewCell {
        if let subwaysIds = atmInfo.subwayIds {
            cell.clearMetroStations()
            for subwayInfo in subwaysIds {
                cell.setupNewStation(color: subwayInfo.color, name: subwayInfo.name)
            }
            cell.configureMetroView()
        }
        return cell
    }

    private func setWorkTimeCell(for cell: ATMDepartmentTableViewCell, with atmInfo: ATMListModelProtocol) -> ATMDepartmentTableViewCell {

        cell.workTimeLabel.text = atmInfo.workTime

        return cell
    }
}

// MARK: - Data Source Extension
extension CardViewVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let atmInfo = atmInfo else { return 0 }
        if let subwaysIds = atmInfo.subwayIds {
            if subwaysIds.count > 0 {
                return 4
            }
        }
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let atmInfo = atmInfo else { return UITableViewCell() }

        //Ячейка выбранного продукта
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ATMHeaderTableViewCell.reuseId, for: indexPath) as? ATMHeaderTableViewCell else { return UITableViewCell()}
            cell.accessibilityIdentifier = "BottomCardCellHeader"
            return setHeaderCell(for: cell, with: atmInfo)
        }

        //Ячейка адреса выбранного продукта
        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ATMAddressTableViewCell.reuseId, for: indexPath) as? ATMAddressTableViewCell else { return UITableViewCell()}
            cell.addressLabel.text = atmInfo.addressFull
            cell.accessibilityIdentifier = "BottomCardCellAddress"
            return cell
        }
        if indexPath.row == 2 {
            if let subwaysIds = atmInfo.subwayIds {
                if subwaysIds.count > 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ATMMetroStationTableViewCell.reuseId, for: indexPath) as? ATMMetroStationTableViewCell else { return UITableViewCell()}
                    cell.accessibilityIdentifier = "BottomCardCellSubways"
                    return setSubwayInfoCell(for: cell, with: atmInfo)
                }
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ATMDepartmentTableViewCell.reuseId, for: indexPath) as? ATMDepartmentTableViewCell else { return UITableViewCell()}

                return setWorkTimeCell(for: cell, with: atmInfo)
            }
        }
        if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ATMDepartmentTableViewCell.reuseId, for: indexPath) as? ATMDepartmentTableViewCell else { return UITableViewCell()}

            return setWorkTimeCell(for: cell, with: atmInfo)
        }
        return UITableViewCell()
    }
}

extension CardViewVC: BottomCardShowProtocol {

    ///Размер отображаемой части
    var contentSize: CGFloat {
        return arrowImage.frame.height + tableView.contentSize.height + 44
    }

    ///Закрытие контроллера
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}

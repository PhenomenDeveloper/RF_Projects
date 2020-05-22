//
//  ATMListVC.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit
import CoreLocation

protocol ATMListVCProtocol: UIViewController {

}

enum ATMListDataType {
    case allNeededAtms
    case sybwaysAtms(subway: SubwayListModelProtocol)
}

class ATMListVC: UIViewController {

    // MARK: - Свойства

    var configurator: ATMListConfiguratorProtocol = ATMListConfigurator()
    var presenter: ATMListPresenterProtocol?
    let bottomCardPresentor = TransitionCardFromBottom(presentDuration: 0.6, dismissDuration: 0.25, interactionController: nil)

    ///Таблица для отображения списка транзакций
    let tableView = UITableView()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private let warningLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "Нет данных удовлетворяющих вашему запросу"
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    // MARK: - Расстановка UI элементов

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel2", style: .plain, target: nil, action: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9529617429, green: 0.9528346658, blue: 0.9614482522, alpha: 1)
        setupTableView()
        setupSpinner()
        setupWarningLabel()
    }

    /// Установка UITableView
    private func setupTableView() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 0)

        view.addSubview(tableView)

        setupConstraints()
        tableView.register(ATMListTableViewCell.self, forCellReuseIdentifier: ATMListTableViewCell.reuseId)
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

    ///Устанавливает spinner
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }

    private func setupWarningLabel() {
        view.addSubview(warningLabel)
        warningLabel.setPosition(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setTitleLabel(with string: String) {
        navigationItem.title = string
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18, weight: .regular)]

    }

    // MARK: - Работа с БД

    func loadAtmsData(dataType: ATMListDataType) {
        switch dataType {
        case .allNeededAtms:
            configurator.configureView(with: self)
            loadATMs()
        case .sybwaysAtms(let subway):
            configurator.configureView(with: self)
            setTitleLabel(with: subway.name)
            loadAtmsForSubway(subway: subway)
        }
    }

    private func loadATMs() {

        spinner.startAnimating()
        presenter?.getAtmsList(completion: {[weak self] (result) in
            if result > 0 {
                OperationQueue.main.addOperation {
                    self?.warningLabel.isHidden = true
                    self?.spinner.stopAnimating()
                    self?.tableView.reloadData()
                }
            } else {
                self?.warningLabel.isHidden = false
                self?.spinner.stopAnimating()
                self?.tableView.reloadData()
            }
        })
    }

    private func loadAtmsForSubway(subway: SubwayListModelProtocol) {
        spinner.startAnimating()
        presenter?.getAtmsForSubway(subway: subway, completion: {[weak self] (result) in
            if result > 0 {
                OperationQueue.main.addOperation {
                    self?.warningLabel.isHidden = true
                    self?.spinner.stopAnimating()
                    self?.tableView.reloadData()
                }
            } else {
                self?.warningLabel.isHidden = false
                self?.spinner.stopAnimating()
                self?.tableView.reloadData()
            }
        })
    }

    // MARK: - Вспомогательные функции

    /// Устанавливает необходимую картинку для ячейки и задает ей нужный идентификатор
    ///
    /// - Parameters:
    ///     - cell: Ячейка таблицы
    ///     - atmObject: Модель ячейки
    private func getContentImageAndIdentifierForCell(for cell: ATMListTableViewCell, atmObject: ATMListModelProtocol) {
        switch atmObject.typeId {
        case 1:
            cell.accessibilityIdentifier? += "Department"
            cell.placeImageView.image = UIImage(named: "icDepartment")
        case 3:
            cell.accessibilityIdentifier? += "Atm"
            cell.placeImageView.image = UIImage(named: "icAtm")
        case 102:
            cell.accessibilityIdentifier? += "Terminal"
            cell.placeImageView.image = UIImage(named: "icTerminal")
        default:
            break
        }
    }
}

// MARK: - Data Source Extension

extension ATMListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            return 0
        }
        return presenter.getAtmsListCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ATMListTableViewCell.reuseId, for: indexPath) as? ATMListTableViewCell else { return UITableViewCell() }

        cell.accessibilityIdentifier = "ATMsCell"

        guard let presenter = presenter else {
            return cell
        }
        let atmModel = presenter.getAtmsInfo(forIndex: indexPath.row)

        cell.placeTypeCircle.mainColor = #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1)
        getContentImageAndIdentifierForCell(for: cell, atmObject: atmModel)
        cell.placeName.text = atmModel.bankName
        cell.placeAddress.text = atmModel.addressFull

        if let subwaysIds = atmModel.subwayIds {
            cell.clearMetroStations()
            for subwayInfo in subwaysIds {
                cell.setupNewStation(color: subwayInfo.color, name: subwayInfo.name)
            }
            cell.configureMetroView()
        } else {
            cell.clearMetroStations()
            cell.configureMetroView()
        }

        cell.placeDistanceValue.text = "\(atmModel.distanceToCurrentUser) м"

        return cell
    }

}

extension ATMListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        //Попробовать убрать bounce эффект в dismiss анимации и сделать все элементы isUserInteractionEnabled = false, чтобы пользователь мог достучаться до таблицы
//        let card = BottomCardVC()
//        card.modalPresentationStyle = .overCurrentContext
//        card.atmInfo = presenter.getAtmsInfo(forIndex: indexPath.row)
        OperationQueue.main.addOperation {
            presenter.showDetailInfo(for: indexPath.row)
//            self.present(card, animated: false, completion: nil)
        }
    }
}

extension ATMListVC: ATMListVCProtocol {

}

extension ATMListVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        bottomCardPresentor.isPresenting = true
        return bottomCardPresentor
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        bottomCardPresentor.isPresenting = false
        bottomCardPresentor.isDismissing = true
        return bottomCardPresentor
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? TransitionCardFromBottom,
          let interactionController = animator.interactionDismiss,
          interactionController.interactionInProgress
          else {
            return nil
        }
        return interactionController
    }
}

//
//  PlayerVC + UITableViewDataSource.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

extension PlayerVC: UITableViewDataSource {

    ///Количество секций таблицы
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    ///Количество ячеек в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.titleArray.count
    }
    ///Вывод данных в таблицу
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.bandCellId, for: indexPath) as? PlayerTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = viewModel.titleArray[indexPath.row].titulArray
        cell.dataLabel.text = viewModel.dataArray[indexPath.row].dataArray

        return cell
    }

}

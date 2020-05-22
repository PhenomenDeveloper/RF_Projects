//
//  PlayerTableViewCell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    static let bandCellId = "bandCellId"
    ///Ячейка таблицы
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.dropShadow()
        return view
    }()
    ///Название выводимого параметра игрока
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    ///Выводимые данные игрока
    let dataLabel: UILabel = {
        let dataLbl = UILabel()
        dataLbl.text = "Data"
        dataLbl.textColor = .darkGray
        dataLbl.font = UIFont.boldSystemFont(ofSize: 18)
        return dataLbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()

    }
    ///Размещение данных внутри таблицы
    func setup() {
        backgroundColor = .white

        addSubview(cellView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(dataLabel)

        cellView.setPosition(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        titleLabel.setPosition(top: nil, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true

        dataLabel.setPosition(top: nil, left: nil, bottom: nil, right: cellView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        dataLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

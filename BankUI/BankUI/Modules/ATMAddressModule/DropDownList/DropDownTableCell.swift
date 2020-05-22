//
//  DropDownTableCell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class DropDownCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "На карте"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Инициализаторы

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        configureViewComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Настройка внешнего вида окна

    /// Расставляем все необходимые UI компоненты на экране
    private func configureViewComponents() {
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

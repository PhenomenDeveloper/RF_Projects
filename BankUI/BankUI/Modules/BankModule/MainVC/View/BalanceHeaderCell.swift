//
//  BalanceHeaderCell.swift
//  BankUI
//
//  Created by MANVELYAN Gevorg on 12.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class BalanceHeaderCell: UITableViewCell {
    static let reuseId = "BalanceHeaderCell"

    // MARK: - Создание объектов кастомной ячейки

    ///Сама ячейка
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.text = "Карты"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        overlayFirstLayer()
        overlaySecondLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///Наложение первого слоя UI
    private func overlayFirstLayer() {
        addSubview(cardView)

        cardView.fillToSuperView(view: self)
    }

    ///Наложение второго слоя UI
    private func overlaySecondLayer() {

        cardView.addSubview(nameLabel)

        nameLabel.setPosition(top: cardView.topAnchor,
                              left: cardView.leftAnchor,
                              bottom: nil,
                              right: nil,
                              paddingTop: 20,
                              paddingLeft: 12,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
                nameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true

    }

}

//
//  TableMainCell.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class TableMainCell: UITableViewCell {

    // MARK: - Свойства

    ///Иконка ячейки
    let icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .clear
        return image
    }()

    ///Текст ячейки
    let textInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    // MARK: - Инициализаторы

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureComponents()
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Настройка внешнего вида

    private func configureComponents() {

        self.addSubview(icon)
        icon.setPosition(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 18, paddingLeft: 24, paddingBottom: 18, paddingRight: 0, width: 0, height: 0)

        self.addSubview(textInfo)
        textInfo.setPosition(top: nil, left: icon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        textInfo.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
    }
}

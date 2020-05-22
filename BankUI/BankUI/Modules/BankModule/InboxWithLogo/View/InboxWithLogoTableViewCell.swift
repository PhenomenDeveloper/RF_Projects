//
//  InboxWithLogoTableViewCell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 13.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class InboxWithLogoTableViewCell: UITableViewCell {
    static let reuseId = "InboxWithLogoTableViewCell"

    // MARK: - Создание объектов кастомной ячейки

    ///Сама ячейка
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()

    ///Тип операции
    let operationTypeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.inboxTitleFontSize, weight: .semibold)
        label.textColor = ThemeManager.Color.titleColor

        return label
    }()

    ///Где была совершена операция
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.inboxSubtitleFontSize, weight: .regular)
        label.textColor = ThemeManager.Color.titleColor

        return label
    }()

    ///Изображение логотипа
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        image.layer.cornerRadius = 20
        image.backgroundColor = .clear
        return image
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        cardView.layer.cornerRadius = ThemeManager.Corner.cardViewCornerRadius
        cardView.clipsToBounds = true

        overlayFirstLayer()
        overlaySecondLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///Наложение первого слоя UI
    private func overlayFirstLayer() {
        addSubview(cardView)

        cardView.setPosition(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 12,
                             paddingLeft: 16,
                             paddingBottom: 12,
                             paddingRight: 12,
                             width: 0,
                             height: 0)
    }

    ///Наложение второго слоя UI
    private func overlaySecondLayer() {

        cardView.addSubview(operationTypeLabel)

        cardView.addSubview(nameLabel)

        cardView.addSubview(logoImage)

        logoImage.setPosition(top: cardView.topAnchor,
                              left: nil,
                              bottom: nil,
                              right: cardView.rightAnchor,
                              paddingTop: ConstraintsManager.InboxModule.TimeLabel.topConstraint,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: ConstraintsManager.InboxModule.TimeLabel.rightConstraint,
                              width: 60,
                              height: 60)

        operationTypeLabel.setPosition(top: cardView.topAnchor,
                                       left: cardView.leftAnchor,
                                       bottom: nil,
                                       right: logoImage.leftAnchor,
                                       paddingTop: ConstraintsManager.InboxModule.OperationTypeLabel.topConstraint,
                                       paddingLeft: ConstraintsManager.InboxModule.OperationTypeLabel.leftConstraint,
                                       paddingBottom: 0,
                                       paddingRight: 5,
                                       width: 0,
                                       height: 0)

        nameLabel.setPosition(top: operationTypeLabel.bottomAnchor,
                              left: operationTypeLabel.leftAnchor,
                              bottom: cardView.bottomAnchor,
                              right: logoImage.leftAnchor,
                              paddingTop: ConstraintsManager.InboxModule.NameLabel.topConstraint,
                              paddingLeft: ConstraintsManager.InboxModule.NameLabel.leftConstraint,
                              paddingBottom: ConstraintsManager.InboxModule.NameLabel.bottomConstraint,
                              paddingRight: 5,
                              width: 0,
                              height: 0)
    }
}

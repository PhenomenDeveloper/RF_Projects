//
//  AccountsTableViewCell.swift
//  BankUI
//
//  Created by MANVELYAN Gevorg on 14.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class AccountsTableViewCell: UITableViewCell {
    static let reuseId = "AccountsTableViewCell"

    // MARK: - Создание объектов кастомной ячейки

    ///Сама ячейка
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()

    let accountNumber: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = #colorLiteral(red: 0.65092206, green: 0.6510177255, blue: 0.6509010196, alpha: 1)
        return label
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.text = "100 500,00₽"
        return label
    }()

    let accountMiniImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .clear
        return image
    }()

    let accountCircleYellow: CircledDotView = {
        let circle = CircledDotView()
        circle.mainColor = #colorLiteral(red: 1, green: 0.8603625298, blue: 0, alpha: 1)
        circle.translatesAutoresizingMaskIntoConstraints = false

        return circle
    }()

    let accountCircleWhite: CircledDotView = {
        let circle = CircledDotView()
        circle.mainColor = .white
        circle.translatesAutoresizingMaskIntoConstraints = false

        return circle
    }()

    let accountMiniCircleWhite: CircledDotView = {
        let circle = CircledDotView()
        circle.mainColor = .white
        circle.translatesAutoresizingMaskIntoConstraints = false

        return circle
    }()

    let accountMiniCircleBlack: CircledDotView = {
        let circle = CircledDotView()
        circle.mainColor = .black
        circle.translatesAutoresizingMaskIntoConstraints = false

        return circle
    }()

    let accountImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .clear
        return image
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
        cardView.addSubview(accountCircleYellow)
        accountCircleYellow.setPosition(top: nil,
                                        left: cardView.leftAnchor,
                                        bottom: nil,
                                        right: nil,
                                        paddingTop: 0,
                                        paddingLeft: 10,
                                        paddingBottom: 0,
                                        paddingRight: 0,
                                        width: 40,
                                        height: 40)
        accountCircleYellow.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true

        cardView.addSubview(accountCircleWhite)
        accountCircleWhite.setPosition(top: nil,
                                       left: nil,
                                       bottom: nil,
                                       right: nil,
                                       paddingTop: 0,
                                       paddingLeft: 0,
                                       paddingBottom: 0,
                                       paddingRight: 0,
                                       width: 36,
                                       height: 36)
        accountCircleWhite.centerYAnchor.constraint(equalTo: accountCircleYellow.centerYAnchor).isActive = true
        accountCircleWhite.centerXAnchor.constraint(equalTo: accountCircleYellow.centerXAnchor).isActive = true

        cardView.addSubview(accountImage)
        accountImage.setPosition(top: nil,
                                 left: nil,
                                 bottom: nil,
                                 right: nil,
                                 paddingTop: 0,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 0,
                                 width: 24,
                                 height: 24)

        accountImage.centerYAnchor.constraint(equalTo: accountCircleWhite.centerYAnchor).isActive = true
        accountImage.centerXAnchor.constraint(equalTo: accountCircleWhite.centerXAnchor).isActive = true
//        accountImage.isHidden = true

        cardView.addSubview(accountMiniCircleWhite)

        accountMiniCircleWhite.setPosition(top: nil,
                                           left: nil,
                                           bottom: accountCircleYellow.bottomAnchor,
                                           right: accountCircleYellow.rightAnchor,
                                           paddingTop: 0,
                                           paddingLeft: 0,
                                           paddingBottom: -1,
                                           paddingRight: -1,
                                           width: 20,
                                           height: 20)

        cardView.addSubview(accountMiniCircleBlack)

        accountMiniCircleBlack.setPosition(top: nil,
                                           left: nil,
                                           bottom: accountCircleYellow.bottomAnchor,
                                           right: accountCircleYellow.rightAnchor,
                                           paddingTop: 0,
                                           paddingLeft: 0,
                                           paddingBottom: 0,
                                           paddingRight: 0,
                                           width: 16,
                                           height: 16)

        cardView.addSubview(accountMiniImage)

        accountMiniImage.setPosition(top: nil,
                                     left: nil,
                                     bottom: nil,
                                     right: nil,
                                     paddingTop: 0,
                                     paddingLeft: 0,
                                     paddingBottom: 0,
                                     paddingRight: 0,
                                     width: 10,
                                     height: 8)

        accountMiniImage.centerYAnchor.constraint(equalTo: accountMiniCircleBlack.centerYAnchor).isActive = true
        accountMiniImage.centerXAnchor.constraint(equalTo: accountMiniCircleBlack.centerXAnchor).isActive = true
//        accountMiniImage.isHidden = true

        cardView.addSubview(nameLabel)

        nameLabel.setPosition(top: cardView.topAnchor,
                              left: accountCircleYellow.rightAnchor,
                              bottom: nil,
                              right: nil,
                              paddingTop: 16,
                              paddingLeft: 12,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)

        cardView.addSubview(accountNumber)

        accountNumber.setPosition(top: nameLabel.bottomAnchor,
                               left: nameLabel.leftAnchor,
                               bottom: cardView.bottomAnchor,
                               right: nil,
                               paddingTop: 2,
                               paddingLeft: 0,
                               paddingBottom: 12,
                               paddingRight: 0,
                               width: 0,
                               height: 0)

        cardView.addSubview(balanceLabel)

        balanceLabel.setPosition(top: cardView.topAnchor,
                                 left: nil,
                                 bottom: nil,
                                 right: cardView.rightAnchor,
                                 paddingTop: 23,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 13,
                                 width: 0,
                                 height: 0)

    }

}

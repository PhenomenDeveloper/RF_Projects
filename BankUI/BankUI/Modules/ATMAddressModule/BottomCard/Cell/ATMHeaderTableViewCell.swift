//
//  FirstCell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class ATMHeaderTableViewCell: BaseBottomCardCell {
    static let reuseId = "ATMHeaderTableViewCell"

    let circleView = CircledDotView()

    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "icAtm")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view

    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        return label
    }()

    let distance: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = #colorLiteral(red: 0.5999458432, green: 0.600034833, blue: 0.5999264717, alpha: 1)
        label.accessibilityIdentifier = "BottomCardDistance"
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func overlayFirstLayer() {
        super.overlayFirstLayer()
    }

    override func overlaySecondLayer() {

        cardView.addSubview(circleView)
        circleView.setPosition(top: nil,
                           left: cardView.leftAnchor,
                           bottom: nil,
                           right: nil,
                           paddingTop: 16,
                           paddingLeft: 16,
                           paddingBottom: 16,
                           paddingRight: 0,
                           width: 40,
                           height: 40)

        circleView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        circleView.mainColor = #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1)

        cardView.addSubview(logoImageView)
        logoImageView.setPosition(top: nil,
                         left: nil,
                         bottom: nil,
                         right: nil,
                         paddingTop: 0,
                         paddingLeft: 0,
                         paddingBottom: 0,
                         paddingRight: 0,
                         width: 24,
                         height: 24)

        logoImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true

        cardView.addSubview(titleLabel)
        titleLabel.setPosition(top: cardView.topAnchor,
                               left: circleView.rightAnchor,
                               bottom: cardView.bottomAnchor,
                               right: nil,
                               paddingTop: 23,
                               paddingLeft: 16,
                               paddingBottom: 23,
                               paddingRight: 0,
                               width: 0,
                               height: 0)

        titleLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true

        cardView.addSubview(distance)
        distance.setPosition(top: nil,
                             left: nil,
                             bottom: nil,
                             right: cardView.rightAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 16,
                             width: 0,
                             height: 0)

        distance.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
    }

}

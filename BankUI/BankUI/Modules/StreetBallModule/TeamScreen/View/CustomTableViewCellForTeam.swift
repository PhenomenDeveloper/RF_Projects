//
//  CustomTableViewCellForTeam.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

protocol CustomTableViewCellProtocolForTeam {
    static var reuseId: String { get }

    func overlayFirstLayer()
    func overlaySecondLayer()
}

class CustomTableViewCellForTeam: UITableViewCell, CustomTableViewCellProtocolForTeam {

    static let reuseId = "CustomTableViewCell"

    // MARK: - Создание объектов кастомной ячейки
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let playerNumberLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let playerNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let playerSurnameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        setupShadow()
        overlayFirstLayer()
        overlaySecondLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3.0
    }

    ///Наложение первого слоя UI
    func overlayFirstLayer() {
        addSubview(cardView)
        cardView.setPosition(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 6,
                             paddingLeft: 15,
                             paddingBottom: 6,
                             paddingRight: 16,
                             width: 0,
                             height: 40)
    }

    ///Наложение второго слоя UI
    func overlaySecondLayer() {
        cardView.addSubview(playerNumberLabel)

        playerNumberLabel.setPosition(top: nil,
                                      left: cardView.leftAnchor,
                                      bottom: nil,
                                      right: nil,
                                      paddingTop: 0,
                                      paddingLeft: 5,
                                      paddingBottom: 0,
                                      paddingRight: 0,
                                      width: 0,
                                      height: 20)
        playerNumberLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        cardView.addSubview(playerSurnameLabel)

        playerSurnameLabel.setPosition(top: nil,
                                       left: cardView.leftAnchor,
                                       bottom: nil,
                                       right: nil,
                                       paddingTop: 0,
                                       paddingLeft: 35,
                                       paddingBottom: 0,
                                       paddingRight: 0,
                                       width: 0,
                                       height: 20)
        playerSurnameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true

        cardView.addSubview(playerNameLabel)

        playerNameLabel.setPosition(top: nil,
                                    left: playerSurnameLabel.rightAnchor,
                                    bottom: nil,
                                    right: nil,
                                    paddingTop: 0,
                                    paddingLeft: 5,
                                    paddingBottom: 0,
                                    paddingRight: 0,
                                    width: 0,
                                    height: 20)
        playerNameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
    }

}

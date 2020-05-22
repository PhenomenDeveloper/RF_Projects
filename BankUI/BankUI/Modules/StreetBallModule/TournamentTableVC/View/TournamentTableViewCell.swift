//
//  TournamentTableViewCell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

protocol TableViewCellProtocol {
    static var reuseId: String { get }

    func overlayFirstLayer()
    func overlaySecondLayer()
}

class TournamentTableViewCell: UITableViewCell, TableViewCellProtocol {
    static let reuseId = "CustomTableViewCell"

    // MARK: - Создание объектов кастомной ячейки
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let numberLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let teamAvatar: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView

    }()

    let teamNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let teamWinrateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let teamScoreLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
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
                             paddingLeft: 16,
                             paddingBottom: 6,
                             paddingRight: 16,
                             width: 0,
                             height: 0)
    }

    ///Наложение второго слоя UI
    func overlaySecondLayer() {
        cardView.addSubview(numberLabel)

        numberLabel.setPosition(top: cardView.topAnchor,
                                left: cardView.leftAnchor,
                                bottom: cardView.bottomAnchor,
                                right: nil,
                                paddingTop: 5,
                                paddingLeft: 10,
                                paddingBottom: 5,
                                paddingRight: 0,
                                width: 0,
                                height: 0)

        cardView.addSubview(teamAvatar)

        teamAvatar.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        teamAvatar.setPosition(top: cardView.topAnchor,
                               left: numberLabel.rightAnchor,
                               bottom: cardView.bottomAnchor,
                               right: nil,
                               paddingTop: 5,
                               paddingLeft: 10,
                               paddingBottom: 5,
                               paddingRight: 0,
                               width: 60,
                               height: 60)

        cardView.addSubview(teamNameLabel)

        teamNameLabel.setPosition(top: cardView.topAnchor,
                                  left: teamAvatar.rightAnchor,
                                  bottom: nil,
                                  right: nil,
                                  paddingTop: 10,
                                  paddingLeft: 15,
                                  paddingBottom: 0,
                                  paddingRight: 0,
                                  width: 0,
                                  height: 0)

        cardView.addSubview(teamWinrateLabel)

        teamWinrateLabel.setPosition(top: teamNameLabel.bottomAnchor,
                                  left: teamNameLabel.leftAnchor,
                                  bottom: cardView.bottomAnchor,
                                  right: nil,
                                  paddingTop: 5,
                                  paddingLeft: 0,
                                  paddingBottom: 5,
                                  paddingRight: 0,
                                  width: 0,
                                  height: 0)

        cardView.addSubview(teamScoreLabel)

        teamScoreLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        teamScoreLabel.setPosition(top: nil,
                                  left: nil,
                                  bottom: nil,
                                  right: cardView.rightAnchor,
                                  paddingTop: 10,
                                  paddingLeft: 0,
                                  paddingBottom: 0,
                                  paddingRight: 7,
                                  width: 0,
                                  height: 0)
    }
}

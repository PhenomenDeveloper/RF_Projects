//
//  CalendarTableCell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

protocol CalendarCellProtocol: class {

    ///Нажато изображение домашней команды
    /// - Parameters:
    ///     - teamName: Название выбранной команды
    func homeTeamImageClicked(with cellIndex: Int)

    ///Нажато изображение гостевой команды
    /// - Parameters:
    ///     - teamName: Название выбранной команды
    func guestTeamImageClicked(with cellIndex: Int)
}

class CalendarCell: UITableViewCell {

    // MARK: - Свойства

    weak var delegate: CalendarCellProtocol?

    var index: Int!

    ///Контейнер для содержимого ячейки таблицы (Чтобы сделать ячейку с тенью необходим контейнер)
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    ///Дата матча
    let matchTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    ///Картинка домашней команды
    lazy var homeImageTeam: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        image.layer.cornerRadius = 20
        image.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(homeTeamImageClicked))
        tap.numberOfTapsRequired = 1
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tap)

        return image
    }()

    ///Название домашней команды
    let homeTeamNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    }()

    ///Счет домашней команды
    let homeScoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()

    ///Картинка гостевой команды
    lazy var guestImageTeam: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        image.layer.cornerRadius = 20
        image.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(guestTeamImageClicked))
        tap.numberOfTapsRequired = 1
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tap)

        return image
    }()

    ///Название гостевой команды
    let guestTeamNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    }()

    ///Счет гостевой команды
    let guestScoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()

    ///Разделитель
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    ///Статус игры
    let stateOfGameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    // MARK: - Инициализаторы

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true

        configureViewComponents()
        setupShadow()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Настройка внешнего вида окна

    /// Расставляем все необходимые UI компоненты на экране
    private func configureViewComponents() {

        //Общий контейнер
        addSubview(cardView)
        cardView.setPosition(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 12, paddingRight: 16, width: 0, height: 0)

        //Дата матча
        cardView.addSubview(matchTimeLabel)
        matchTimeLabel.setPosition(top: cardView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        matchTimeLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true

        //Картинка домашней команды
        cardView.addSubview(homeImageTeam)
        homeImageTeam.setPosition(top: matchTimeLabel.bottomAnchor, left: cardView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        homeImageTeam.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true

        //Название домашней команды
        cardView.addSubview(homeTeamNameLabel)
        homeTeamNameLabel.setPosition(top: homeImageTeam.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        homeTeamNameLabel.centerXAnchor.constraint(equalTo: homeImageTeam.centerXAnchor).isActive = true

        //Картинка гостевой команды
        cardView.addSubview(guestImageTeam)
        guestImageTeam.setPosition(top: matchTimeLabel.bottomAnchor, left: nil, bottom: nil, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 80, height: 80)
        guestImageTeam.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true

        //Название гостевой команды
        cardView.addSubview(guestTeamNameLabel)
        guestTeamNameLabel.setPosition(top: guestImageTeam.bottomAnchor, left: nil, bottom: nil, right: guestImageTeam.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        guestTeamNameLabel.centerXAnchor.constraint(equalTo: guestImageTeam.centerXAnchor).isActive = true

        //Сепаратор
        cardView.addSubview(separatorView)
        separatorView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        separatorView.setPosition(top: homeImageTeam.topAnchor, left: nil, bottom: homeImageTeam.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 1, height: 0)

        //Счет домашней команды
        cardView.addSubview(homeScoreLabel)
        homeScoreLabel.setPosition(top: nil, left: nil, bottom: nil, right: separatorView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        homeScoreLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true

        //Счет гостевой команды
        cardView.addSubview(guestScoreLabel)
        guestScoreLabel.setPosition(top: nil, left: separatorView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        guestScoreLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true

        //Состояние матча
        cardView.addSubview(stateOfGameLabel)
        stateOfGameLabel.setPosition(top: guestTeamNameLabel.bottomAnchor, left: nil, bottom: cardView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 3, paddingRight: 0, width: 0, height: 0)

        stateOfGameLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
    }

    ///Установка тени для ячейки таблицы
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 3.0
    }

    // MARK: - Обработка нажатий

    @objc private func homeTeamImageClicked() {
        delegate?.homeTeamImageClicked(with: index)
    }

    @objc private func guestTeamImageClicked() {
        delegate?.guestTeamImageClicked(with: index)
    }

}

//
//  ATMListTableViewCell.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class ATMListTableViewCell: UITableViewCell {
    static let reuseId = "ATMListTableViewCell"

    var metroStations: [MetroStationView] = []

    private var metroStationStackView: UIStackView = UIStackView()

    // MARK: - Создание объектов кастомной ячейки

    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let placeTypeCircle: CircledDotView = {
        let circle = CircledDotView()
        circle.translatesAutoresizingMaskIntoConstraints = false

        return circle
    }()

    let placeImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let placeName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)

        return label
    }()

    let placeAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.accessibilityIdentifier = "ATMsCellAddress"

        return label
    }()

    let placeDistanceValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.accessibilityIdentifier = "ATMsCellDistance"

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        setupMetroStackView()
        overlayFirstLayer()
        overlaySecondLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Настройка UI

    ///Наложение первого слоя UI
    private func overlayFirstLayer() {
        addSubview(cardView)

        cardView.setPosition(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: 0)
    }

    ///Наложение второго слоя UI
    private func overlaySecondLayer() {

        cardView.addSubview(placeTypeCircle)
        cardView.addSubview(placeImageView)
        cardView.addSubview(placeName)
        cardView.addSubview(placeAddress)
        cardView.addSubview(placeDistanceValue)

        placeTypeCircle.setPosition(top: cardView.topAnchor,
                                    left: cardView.leftAnchor,
                                    bottom: nil,
                                    right: nil,
                                    paddingTop: 12,
                                    paddingLeft: 16,
                                    paddingBottom: 0,
                                    paddingRight: 0,
                                    width: 40,
                                    height: 40)

        placeImageView.centerXAnchor.constraint(equalTo: placeTypeCircle.centerXAnchor).isActive = true
        placeImageView.centerYAnchor.constraint(equalTo: placeTypeCircle.centerYAnchor).isActive = true
        placeImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        placeImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true

        placeName.setPosition(top: cardView.topAnchor,
                              left: placeTypeCircle.rightAnchor,
                              bottom: nil,
                              right: placeDistanceValue.leftAnchor,
                              paddingTop: 14,
                              paddingLeft: 16,
                              paddingBottom: 0,
                              paddingRight: 28,
                              width: 0,
                              height: 0)

        placeAddress.setPosition(top: placeName.bottomAnchor,
                                 left: placeName.leftAnchor,
                                 bottom: nil,
                                 right: cardView.rightAnchor,
                                 paddingTop: 2,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 85,
                                 width: 0,
                                 height: 0)

        placeDistanceValue.setPosition(top: cardView.topAnchor,
                                       left: cardView.rightAnchor,
                                       bottom: nil,
                                       right: nil,
                                       paddingTop: 16,
                                       paddingLeft: -55,
                                       paddingBottom: 0,
                                       paddingRight: 0,
                                       width: 0,
                                       height: 0)

        cardView.addSubview(metroStationStackView)

        metroStationStackView.setPosition(top: placeAddress.bottomAnchor,
                                          left: placeAddress.leftAnchor,
                                          bottom: cardView.bottomAnchor,
                                          right: placeAddress.rightAnchor,
                                          paddingTop: 8,
                                          paddingLeft: 0,
                                          paddingBottom: 12,
                                          paddingRight: 0,
                                          width: 0,
                                          height: 0)
    }

    ///Настройка стека для отображения станций метро
    private func setupMetroStackView() {
        metroStationStackView.axis = .vertical
        metroStationStackView.distribution = .equalSpacing
        metroStationStackView.spacing = 5
    }

    // MARK: - Вспомогательные функции

    ///Очищает массив метро
    func clearMetroStations() {
        //Так как ячейки переиспользуются, то массив необходимо очищать, иначе он будет расти каждый раз как будет появляться новая ячейка
        metroStations.removeAll()
    }

    ///Устанавливает данные для отображения станции метро
    ///
    /// - Parameters:
    ///     - color: Цвет метро
    ///     - name: Название станции
    func setupNewStation(color: String, name: String) {

        let metroStationView = MetroStationView()
        metroStationView.stationCircleView.mainColor = UIColor(hexString: color)
        metroStationView.stationNameLabel.text = name
        metroStations.append(metroStationView)
    }

    ///Добавляет в стек необходимые данные о метро для отображения
    func configureMetroView() {

        for subview in metroStationStackView.arrangedSubviews {
            subview.removeFromSuperview()
            metroStationStackView.removeArrangedSubview(subview)
        }

        if metroStations.count > 0 {
            for i in 0..<metroStations.count {
                metroStationStackView.addArrangedSubview(metroStations[i])
            }
        }
    }
}

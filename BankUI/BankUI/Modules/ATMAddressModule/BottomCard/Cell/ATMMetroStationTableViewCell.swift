//
//  ThridCell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class ATMMetroStationTableViewCell: BaseBottomCardCell {
    static let reuseId = "ATMMetroStationTableViewCell"

    var metroStations: [MetroStationView] = []

    private var metroStationStackView: UIStackView = UIStackView()

    let closestSubwayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Ближайшее метро"
        label.textColor = #colorLiteral(red: 0.5999458432, green: 0.600034833, blue: 0.5999264717, alpha: 1)

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMetroStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Настройка UI

    override func overlayFirstLayer() {
        super.overlayFirstLayer()
    }

    override func overlaySecondLayer() {

        cardView.addSubview(closestSubwayLabel)
        closestSubwayLabel.setPosition(top: cardView.topAnchor,
                                       left: cardView.leftAnchor,
                                       bottom: nil,
                                       right: nil,
                                       paddingTop: 12,
                                       paddingLeft: 16,
                                       paddingBottom: 0,
                                       paddingRight: 0,
                                       width: 0,
                                       height: 0)
        cardView.addSubview(metroStationStackView)

        metroStationStackView.setPosition(top: closestSubwayLabel.bottomAnchor,
                                          left: cardView.leftAnchor,
                                          bottom: cardView.bottomAnchor,
                                          right: cardView.rightAnchor,
                                          paddingTop: 8,
                                          paddingLeft: 16,
                                          paddingBottom: 12,
                                          paddingRight: 16,
                                          width: 0,
                                          height: 0)

    }

    // MARK: - Вспомогательные функции

    private func setupMetroStackView() {

        metroStationStackView.axis = .vertical
        metroStationStackView.distribution = .equalSpacing
        metroStationStackView.spacing = 10
    }

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

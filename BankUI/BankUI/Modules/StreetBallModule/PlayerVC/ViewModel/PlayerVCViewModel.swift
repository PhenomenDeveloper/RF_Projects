//
//  PlayerVCViewModel.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation
import CoreData

class PlayerVCViewModel: PlayerViewModelProtocol {

    // MARK: - Свойства

    var nameLabel: String
    var teamLabel: String
    var model: PlayerModelProtocol
    var player: PlayerCD?
    var team: TeamCD?
    var titleArray: [Title] = []
    var dataArray: [Datas] = []

    // MARK: - Инициализатор

    init(playerModel: PlayerModelProtocol) {
        model = playerModel
        player = model.getPlayer()
        team = model.getTeam()
        teamLabel = team?.name ?? ""
        nameLabel = (player?.surName ?? "") + "\n" + (player?.name ?? "")
        titleArray = [Title(titulArray: "Дата рождения: "),
                      Title(titulArray: "Рост: "),
                      Title(titulArray: "Вес: "),
                      Title(titulArray: "Позиция: "),
                      Title(titulArray: "Игровой номер: "),
                      Title(titulArray: "Звание: ")
        ]
        guard let player = player, let position = player.position, let dateBirth = player.dateBirth else { return }

        dataArray = [Datas(dataArray: convertToString(dateString: dateBirth, formatIn: "yyyy-MM-dd", formatOut: "dd.MM.yyyy")),
                     Datas(dataArray: String(describing: player.hieght) + " см"),
                     Datas(dataArray: String(describing: player.weight) + " кг"),
                     Datas(dataArray: translatePosition(position: position)),
                     Datas(dataArray: String(describing: player.number)),
                     Datas(dataArray: player.titul ?? "Нет")
    ]
    }

    ///Перевод даты в строку и преобразование даты в другой формат вывода
    /// - Parameters:
    ///     - dateString: Выводимая строка
    ///     - formatIn: Входной формат
    ///     - formatOut: Выходной формат
    /// - Returns:
    ///     Возвращает строку с нужном форматом даты
    func convertToString (dateString: String, formatIn: String, formatOut: String) -> String {

        let dateFormater = DateFormatter()
        dateFormater.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        dateFormater.dateFormat = formatIn
        let date = dateFormater.date(from: dateString)

        dateFormater.timeZone = NSTimeZone.system

        dateFormater.dateFormat = formatOut
        let timeStr = dateFormater.string(from: date!)
        return timeStr
    }
    ///Переводит данные с англ на русский
    /// - Parameters:
    ///     - position: Строка, которую необходимо перевести
    /// - Returns:
    ///     Возвращает значение на русском языке
    func translatePosition (position: String) -> String {
        switch position {
        case "guard":
            return "Защитник"
        case "forward":
            return "Нападающий"
        case "center":
            return "Полузащитник"
        default:
            return "Отсутствует"
        }
    }
}

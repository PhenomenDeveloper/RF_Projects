//
//  LoadATMsError.swift
//  BankUI
//
//  Created by Lev Kolesnikov on 21.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

enum LoadATMsAndSubwaysError: Error {
    case ATMsNotExist
    case SubwaysNotExist
    case operationIsCancelled
    case notRealmConnected
    case realmWriteDataError
    case unexpectedError
    case networkError

    var localizedDescription: String {
        switch self {
        case .operationIsCancelled:
            return "Операция была прервана"
        case .ATMsNotExist:
            return "Банковские объекты не найдены"
        case .SubwaysNotExist:
            return "Информация о метро не найдена"
        case .notRealmConnected:
            return "Не получилось подключиться к БД Realm"
        case .realmWriteDataError:
            return "Ошибка записи данных в БД realm"
        case .unexpectedError:
            return "Непредвиденная ошибка"
        case .networkError:
            return "Ошибка получения данных из сети"
        }
    }
}

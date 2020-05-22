//
//  LoadTransactionsError.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

enum LoadTransactionsError: Error {
    case transactionsNotExist
    case operationIsCancelled
    case notRealmConnected
    case realmWriteDataError
    case unexpectedError

    var localizedDescription: String {
        switch self {
        case .operationIsCancelled:
            return "Операция была прервана"
        case .transactionsNotExist:
            return "Транзакций нету"
        case .notRealmConnected:
            return "Не получилось подключиться к БД Realm"
        case .realmWriteDataError:
            return "Ошибка записи данных в БД realm"
        case .unexpectedError:
            return "Непредвиденная ошибка"
        }
    }
}

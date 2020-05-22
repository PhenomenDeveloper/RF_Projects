//
//  LoadTransactionsAndWriteInRealm.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

class LoadTransactionsAndWriteInRealmProvider {

    private let operationQueue = OperationQueue()

    init(completion: @escaping (Result<Int, LoadTransactionsError>) -> Void) {

        // Создаем операции
        let loadTransactions = LoadTransactionsOperation()
        let writeInRealm = WriteTransactionInRealmOperation(completion: completion)

        let operations = [loadTransactions, writeInRealm]

        // Добавляем зависимость к операции записи в БД от операции загрузки транзакций
        writeInRealm.addDependency(loadTransactions)

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

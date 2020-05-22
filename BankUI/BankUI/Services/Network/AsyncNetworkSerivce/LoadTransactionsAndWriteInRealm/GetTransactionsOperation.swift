//
//  GetTransactionsOperation.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

///Протокол который гарантирует, что объект его реализующий будет иметь список загруженных транзакций
protocol LoadedTransactionsProtocol {
    var transactions: [TransactionWithLogoProtocol]? { get }
}

class GetTransactionsOperation: AsyncOperation {

    ///Список транзакций
    private var inputTransactions: [TransactionWithLogoProtocol]?

    public init(transactions: [TransactionWithLogoProtocol]?) {
        inputTransactions = transactions
        super.init()
    }

    ///Загруженные транзакции
    public var loadedTransactions: [TransactionWithLogoProtocol]? {
        var transactions: [TransactionWithLogoProtocol]?
        //Проверяем, задан ли список транзакций у операции
        if let inputTransactions = self.inputTransactions {
            transactions = inputTransactions
        }
        //Если нет, то анализируем dependencies, которые подтверждают протокол LoadedTransactionsProtocol, откуда мы и берем данные
        else if let dataProvider = dependencies.filter({ $0 is LoadedTransactionsProtocol}).first as? LoadedTransactionsProtocol {
            transactions = dataProvider.transactions
        }
        return transactions
    }
}

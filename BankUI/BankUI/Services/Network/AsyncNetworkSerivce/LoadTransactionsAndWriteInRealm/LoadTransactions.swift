//
//  LoadTransactions.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

class LoadTransactionsOperation: AsyncOperation {

    ///Объект для загрузки данных транзакций
    private var networkDataFetcher: DataFetcherProtocol
    ///Загруженные данные транзакций
    private var outputTransactions: [TransactionWithLogoProtocol]?

    override init() {
        self.networkDataFetcher = NetworkDataFetcher(networking: NetworkService())
        super.init()
    }

    override public func main() {
        if self.isCancelled { return }
        networkDataFetcher.getHistoryDataWithLogo { (transactionsList) in
            if self.isCancelled { return }
            if let transactions = transactionsList?.list {
                print("Загружены транзакции в количестве - \(transactions.count)")
                self.outputTransactions = []
                for transaction in transactions {
                    self.outputTransactions?.append(TransactionWithLogo(date: transaction.date,
                                                                        pan: transaction.pan,
                                                                        merchant: transaction.merchant,
                                                                        merchantLogoId: transaction.merchantLogoId,
                                                                        site: transaction.site,
                                                                        amount: transaction.amount,
                                                                        symbol: transaction.billCurrency.symbol))
                }
            }
            self.state = .finished
        }
    }
}

extension LoadTransactionsOperation: LoadedTransactionsProtocol {
    var transactions: [TransactionWithLogoProtocol]? {
        return outputTransactions
    }
}

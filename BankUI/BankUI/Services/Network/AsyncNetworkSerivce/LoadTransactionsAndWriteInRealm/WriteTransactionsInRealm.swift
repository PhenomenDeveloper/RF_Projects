//
//  WriteTransactionsInRealm.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import RealmSwift

class WriteTransactionInRealmOperation: GetTransactionsOperation {

    private let completion: (Result<Int, LoadTransactionsError>) -> Void

    public init(completion: @escaping (Result<Int, LoadTransactionsError>) -> Void) {
        self.completion = completion
        super.init(transactions: nil)
    }

    override public func main() {
        if isCancelled { completion(.failure(.operationIsCancelled)) }

        if let transactions = loadedTransactions {
            print("Мы получили транзакции в количестве - \(transactions.count)\n")
            guard let realm = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .transactionsConfiguration))
                else {
                completion(.failure(.notRealmConnected))
                self.state = .finished
                return
            }
            for transaction in transactions {
                let realmTransaction = getRealmTransaction(transaction: transaction)
                do {
                    try realm.write {
                        realm.add(realmTransaction)
                    }
                } catch {
                    print("Ошибка в сохранении категории - \(error.localizedDescription)")
                    completion(.failure(.realmWriteDataError))
                    self.state = .finished
                    return
                }
            }
            completion(.success(transactions.count))
        } else {
            completion(.failure(.transactionsNotExist))
        }
        self.state = .finished
    }

    private func getRealmTransaction(transaction: TransactionWithLogoProtocol) -> RealmTransaction {
        let realmTransaction = RealmTransaction()
        realmTransaction.date = transaction.date
        realmTransaction.amount = abs(transaction.amount)
        realmTransaction.currencySymbol = transaction.symbol
        realmTransaction.merchant = transaction.merchant
        realmTransaction.merchantLogoId = transaction.merchantLogoId
        realmTransaction.secureCardNumber = transaction.pan
        realmTransaction.site = transaction.site == "" ? nil : transaction.site

        return realmTransaction
    }
}

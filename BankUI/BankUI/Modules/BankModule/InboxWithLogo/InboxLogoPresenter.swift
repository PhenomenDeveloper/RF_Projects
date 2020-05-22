//
//  InboxLogoPresenter.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit
import RealmSwift

protocol InboxLogoPresenterProtocol: class {
    func getPhotoImage(with urlString: String, completion: @escaping (UIImage?) -> Void)
    func getTransactions(completion: @escaping () -> Void)
    func getOrderedDate(at index: Int) -> Date
    func getTransactionsKeysCount() -> Int
    func getTransactionsCount(forKey key: Date) -> Int
    func getTransactions(forKey key: Date) -> [RealmTransactionProtocol]
}

class InboxLogoPresenter {
    // MARK: - Свойства

    weak var view: InboxLogoVCProtocol?
    var interactor: InboxLogoInteractorProtocol?

    ///Данные из БД
    public var transactionsHistory: [Date: [RealmTransactionProtocol]] = [:]
    public var orderedDates: [Date] = []

    required init(view: InboxLogoVCProtocol) {
        self.view = view
    }

    // MARK: - Вспомогательные функции

    ///Сортирует транзакции по датам
    private func orderTransactionByDate(transactions: Results<RealmTransaction>) {
        // 1. Сортировать по дате
        var calendar: Calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!

        //Заполняем уникальными датами
        for transaction in transactions {
            let date: Date? = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: transaction.date))
            transactionsHistory[date!] = []
        }
        self.orderedDates = transactionsHistory.keys.sorted(by: >)

        //Каждой дате ставим в соответствие транзакцию
        for transaction in transactions {
            let date: Date? = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: transaction.date))
            transactionsHistory[date!]?.append(transaction)
        }
    }
}

extension InboxLogoPresenter: InboxLogoPresenterProtocol {

    ///Загружает транзакции из сети или если они есть в локальной БД то из нее
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда все операции закончат свое выполнение
    func getTransactions(completion: @escaping () -> Void) {

        transactionsHistory = [:]
        orderedDates = []

        let realmTransactions = interactor?.loadTransactionFromRealm()

        guard let transactions = realmTransactions else {return}
        if transactions.count == 0 {
            guard let interactor = interactor else { return }

            interactor.loadTransactions(completion: {[weak self] (result) in

                switch result {
                case .success:
                    print("Загрузка и запись транзакций прошла успешно")
                    OperationQueue.main.addOperation {
                        guard let transactionsFromRealm = interactor.loadTransactionFromRealm() else {return}
                        self?.orderTransactionByDate(transactions: transactionsFromRealm)
                        completion()
                    }
                case .failure(let error):
                    print("Ошибка - \(error.localizedDescription)")
                }
            })
        } else {
            print("Транзакции уже находятся в памяти устройства")
            orderTransactionByDate(transactions: transactions)
            completion()
        }
    }

    ///Получение качественного изображения по ссылке
    ///
    /// - Parameters:
    ///     - urlString: ссылка на изображение
    ///     - completion: экземпляр изображения
    func getPhotoImage(with urlString: String, completion: @escaping (UIImage?) -> Void) {

        guard let interactor = interactor else {
            completion(nil)
            return
        }

        interactor.loadPhoto(merchantURL: urlString, completion: { (image) in
            guard let image = image else { return }
            completion(image)
        })
    }

    ///Возвращает дату из отсортированного массива
    ///
    /// - Parameters:
    ///     - index: Индекс необходимой даты из отсортированного массива
    /// - Returns:
    ///     Дата
    func getOrderedDate(at index: Int) -> Date {
        return orderedDates[index]
    }

    ///Возвращает количество дат, которые встречаются в массиве транзакций
    ///
    /// - Returns:
    ///     Количество дат
    func getTransactionsKeysCount() -> Int {
        return transactionsHistory.keys.count
    }

    ///Возвращает количество транзакций совершенных в заданный день
    ///
    /// - Parameters:
    ///     - key: Относительно этой даты вернется количество транзакций
    /// - Returns:
    ///     Количество транзакций совершенных в заданный день
    func getTransactionsCount(forKey key: Date) -> Int {
        guard let values = transactionsHistory[key] else { return 0 }

        return values.count
    }

    ///Возвращает список транзакций совершенных в заданный день
    ///
    /// - Parameters:
    ///     - key: Дата необходимого списка транзакций
    /// - Returns:
    ///     Список транзакций совершенных в заданный день
    func getTransactions(forKey key: Date) -> [RealmTransactionProtocol] {
        guard let transactions = transactionsHistory[key] else {return []}

        return transactions
    }
}

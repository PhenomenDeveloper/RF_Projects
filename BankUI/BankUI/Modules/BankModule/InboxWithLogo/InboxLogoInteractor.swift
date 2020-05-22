//
//  InboxLogoInteractor.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit
import RealmSwift

protocol InboxLogoInteractorProtocol: class {
    func loadTransactions(completion: @escaping (Result<Int, LoadTransactionsError>) -> Void)
    func loadPhoto(merchantURL: String, completion: @escaping (UIImage?) -> Void)
    func loadTransactionFromRealm() -> Results<RealmTransaction>?
}

class InboxLogoInteractor {

    // MARK: - Свойства

    weak var presenter: InboxLogoPresenterProtocol?

    var transactions: Results<RealmTransaction>?

    required init(presenter: InboxLogoPresenterProtocol) {
        self.presenter = presenter
    }
}

extension InboxLogoInteractor: InboxLogoInteractorProtocol {

    ///Загружает транзакции из сети и записывает в локальную БД Realm
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда все операции закончат свое выполнение
    /// - Returns:
    ///     Возвращает объект который занимается этими операциями
    func loadTransactions(completion: @escaping (Result<Int, LoadTransactionsError>) -> Void) {

        _ = LoadTransactionsAndWriteInRealmProvider(completion: completion)
    }

    ///Загружает фото в отдельном потоке
    ///
    /// - Parameters:
    ///     - merchantURL: Адрес по которому загружается изображение
    ///     - completion: Блок кода который выполнится вне данной функции
    /// - Returns:
    ///     Возвращает либо изображение из кэша, либо изображение загруженное из интернета
    func loadPhoto(merchantURL: String, completion: @escaping (UIImage?) -> Void) {

        if let imageName = merchantURL.getImageName(),
            let data = loadImageFromCacheDirectory(imageName: imageName) {

            guard let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            completion(image)
        } else {
            _ = ImageLoadProvider(imageURLString: merchantURL) { image in
                guard let image = image else {
                    return }
                completion(image)
            }

        }
    }

    ///Загружает списко транзакций из БД Realm
    ///
    /// - Returns:
    ///     Список транзакций
    func loadTransactionFromRealm() -> Results<RealmTransaction>? {
        guard let realm = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .transactionsConfiguration)) else {
            print("Не удалось подключиться к БД Realm")
            return nil
        }

        //Загружаем данные из БД
        transactions = realm.objects(RealmTransaction.self)

        return transactions
    }

    /// Загрузка конкретного изображения их кэша
    ///
    /// - Parameters:
    ///     - imageName: название картинки
    /// - Returns:
    ///     Возвращает объект Data, который в дальнейшем пытаемся преобразовать в UIImage
    private func loadImageFromCacheDirectory(imageName: String) -> Data? {
        let fileManager = FileManager.default
        let cachesPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let path = cachesPath else { return nil }
        let pathWithImageName = path.appendingPathComponent(imageName)

        do {
            let data = try Data(contentsOf: pathWithImageName)
            return data
        } catch let error as NSError {
            print("Ошибка, файла с именем \(imageName) нет.")
            print(error.localizedDescription)
            return nil
        }
    }
}

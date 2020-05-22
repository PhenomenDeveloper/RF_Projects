//
//  NetworkDataFetcher.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

protocol DataFetcherProtocol {

    func getNetworkUserData(completion: @escaping (NetworkAuthModelProtocol?) -> Void)
    func getHistoryData(page: Int, completion: @escaping (NetworkContent?) -> Void)
    func getHistoryDataWithLogo(completion: @escaping (TransactionList?) -> Void)
    func getLogoImage(imagePath: String, completion: @escaping (UIImage?) -> Void)
    func getATMPoints(completion: @escaping (Result<Int, LoadATMsAndSubwaysError>) -> Void)
    func getSubwayPoints(completion: @escaping (Result<Int, LoadATMsAndSubwaysError>) -> Void)
}

struct NetworkDataFetcher: DataFetcherProtocol {

    ///Объект которые осуществляет запрос в сеть
    let networking: Netwoking

    init(networking: Netwoking) {
        self.networking = networking
    }

    ///Получает токен авторизации с сервера
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда данные будут получены с сервера
    func getNetworkUserData(completion: @escaping (NetworkAuthModelProtocol?) -> Void) {
        networking.getNetworkUserData(path: APINetwork.auth, params: APINetwork.authParams) { (data, error) in
            if let error = error {
                print("Ошибка получения токена авторизации:  \(error.localizedDescription)")
                completion(nil)
            }

            let decoded = self.decodeJSON(type: NetworkAuthModel.self, from: data, dateFormatter: .historyDateFormatFromJson)

            completion(decoded)
        }
    }

    ///Получает историю транзакций пользователя
    ///
    /// - Parameters:
    ///     - page: Загружаемая страница транзакций
    ///     - completion: Блок кода который необходимо выполнить, когда данные будут получены с сервера
    func getHistoryData(page: Int, completion: @escaping (NetworkContent?) -> Void) {

        networking.getHistoryData(path: APINetwork.history, params: [APINetwork.historyPage: "\(page)"]) { (data, error) in
            if let error = error {
                print("Ошибка получения данных истории транзакций:  \(error.localizedDescription)")
                completion(nil)
            }

            let decoded = self.decodeJSON(type: NetworkContent.self, from: data, dateFormatter: .historyDateFormatFromJson)

            completion(decoded)
        }
    }

    ///Получает историю транзакций пользователя с logo
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда данные будут получены с сервера
    func getHistoryDataWithLogo(completion: @escaping (TransactionList?) -> Void) {
        networking.getHistoryDataWithLogo(path: APINetwork.historyWithLogo, params: [:]) { (data, error) in
            if let error = error {
                print("Ошибка получения данных истории транзакций с логотипом:  \(error.localizedDescription)")
                completion(nil)
            }

            let decoded = self.decodeJSON(type: TransactionList.self, from: data, dateFormatter: .historyDataFormatWithLogoFromJson)

            completion(decoded)
        }
    }

    func getLogoImage(imagePath: String, completion: @escaping (UIImage?) -> Void) {
        networking.getLogoData(imagePath: imagePath) { (data, error) in
           if let error = error {
                print("Ошибка получения логотипа:  \(error.localizedDescription)")
                completion(nil)
            }

            guard let data = data else { return }
            let image = UIImage(data: data)
            completion(image)
        }
    }

    ///Загружает данные о банкоматах и отделениях метро
    ///
    /// - Parameters:
    ///     - completion: Блок кода который оповещает о статусе выполнения загрузки данных
    func getATMPoints(completion: @escaping (Result<Int, LoadATMsAndSubwaysError>) -> Void) {

        networking.getATMsAndSubwaysData(path: ATMDataType.points.dataURL) { (data, error) in

            if let error = error {
                print("Ошибка получения данных о доступных банковских точках:  \(error.localizedDescription)")
                completion(.failure(.networkError))
            }

            let decoded = self.decodeJSON(type: ATMList.self, from: data, dateFormatter: .historyDataFormatWithLogoFromJson)

            guard let atms = decoded?.list else {
                completion(.failure(.ATMsNotExist))
                return
            }

            let filteredATMs = atms.filter {$0.typeId == 1 || $0.typeId == 3 || $0.typeId == 102}

            guard let realm = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .AtmConfiguration)) else {
                completion(.failure(.notRealmConnected))
                return
            }

            for atm in filteredATMs {
                let realmAtm = self.generateRealmATMList(networkModel: atm)

                do {
                    try realm.write {
                        realm.add(realmAtm)
                    }
                } catch {
                    print("Ошибка в сохранении категории - \(error.localizedDescription)")
                    completion(.failure(.realmWriteDataError))
                    return
                }
            }

            completion(.success(atms.count))
        }
    }

    /// Создает модель данных о продукте Банка для записи в БД Realm
    ///
    /// - Parameters:
    ///     - networkModel: Объект данных из сети, который необходимо сохранить в БД
    /// - Returns:
    ///     Модель данных для сохранения в БД Realm
    private func generateRealmATMList(networkModel: ATMList.ATMObject) -> RealmATMList {
        let realmATMList = RealmATMList()
        realmATMList.typeId = networkModel.typeId
        realmATMList.bankName = networkModel.bankName
        realmATMList.latitude = networkModel.latitude
        realmATMList.longitude = networkModel.longitude
        realmATMList.workTime = networkModel.workTime
        if let adressFromHtmlString = networkModel.addressFull?.htmlAttributedString?.string {
            realmATMList.addressFull = adressFromHtmlString
        } else {
            realmATMList.addressFull = networkModel.addressFull
        }

        guard let subways = networkModel.subwayIds else { return realmATMList }

        for subway in subways {
            realmATMList.subwayIds.append(subway)
        }

        return realmATMList
    }

    ///Загружает данные о станциях метро
    ///
    /// - Parameters:
    ///     - completion: Блок кода который оповещает о статусе выполнения загрузки данных
    func getSubwayPoints(completion: @escaping (Result<Int, LoadATMsAndSubwaysError>) -> Void) {

        networking.getATMsAndSubwaysData(path: ATMDataType.subway.dataURL) { (data, error) in
            if let error = error {
                print("Ошибка получения списка метро:  \(error.localizedDescription)")
                completion(.failure(.networkError))
            }

            let decoded = self.decodeJSON(type: [Subway].self, from: data, dateFormatter: .historyDataFormatWithLogoFromJson)

            guard let subways = decoded else {
                completion(.failure(.SubwaysNotExist))
                return
            }

            guard let realm = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .subwayConfiguration)) else {
                completion(.failure(.notRealmConnected))
                return
            }

            for subway in subways {
                let realmAtm = self.generateRealmSubwayList(subway: subway)

                do {
                    try realm.write {
                        realm.add(realmAtm)
                    }
                } catch {
                    print("Ошибка в сохранении категории - \(error.localizedDescription)")
                    completion(.failure(.realmWriteDataError))
                    return
                }
            }

            completion(.success(subways.count))
        }
    }

    /// Создание списка метро
    ///
    /// - Parameters:
    ///     - subway: Модель объекта метро
    /// - Returns:
    ///     Готовая модель данных списка метро из Realm
    private func generateRealmSubwayList(subway: Subway) -> RealmSubwayList {
        let realmSubwayList = RealmSubwayList()

        realmSubwayList.id = subway.id
        realmSubwayList.name = subway.name
        realmSubwayList.latitude = subway.latitude
        realmSubwayList.longitude = subway.longitude
        realmSubwayList.colour = subway.colour

        return realmSubwayList

    }

    ///Декодирует данные полученные из интернета в модель подготовленную для них
    ///
    /// - Parameters:
    ///     - type: Куда хотим упаковать полученный данные
    ///     - from: Данные полученный из сети, которые хотим распаковать
    /// - Returns:
    ///     Возвращает модель заполненную данными полученными из сети
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?, dateFormatter: DateFormatter) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        guard let data = from else { return nil }
        var response: T?
        do {
            response = try decoder.decode(type.self, from: data)
        } catch {
            print("Ошибка декодирования - \(error)")
        }
        return response
    }
}

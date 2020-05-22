//
//  AtmsMapInteractor.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 11.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

protocol AtmsMapInteractorProtocol {
    func loadAtmsListFromRealm(with filters: [(Bool, Int)], with distance: Double, withLocation userLocation: CLLocation) -> [ATMMapModelProtocol]
    func checkDataInRealm() -> Bool
}

class AtmsMapInteractor {

    // MARK: - Свойства

    weak var presenter: AtmsMapPresenterProtocol?

    required init (presenter: AtmsMapPresenterProtocol) {
        self.presenter = presenter
    }
}

extension AtmsMapInteractor: AtmsMapInteractorProtocol {

    ///Получает список Банкоматов, Отделений и Терминалов из БД, которые находятся не дальше чем `distance` от `userLocation`.
    ///
    /// - Parameters:
    ///     - filters: Массив фильтров банковских продуктов, установленных пользователем
    ///     - distance: Максимальное расстояние до искомых Банковских продуктов (Указывается в километрах)
    ///     - userLocation: Текущее местоположение пользователя
    /// - Returns:
    ///     Возвращаеет массив объектов удовлетворяющих запросу пользователя
    func loadAtmsListFromRealm(with filters: [(Bool, Int)], with distance: Double, withLocation userLocation: CLLocation) -> [ATMMapModelProtocol] {

        return RealmQueriesHelper.loadAllAtmsTypeWithFIltersAndUserPosition(with: filters, with: distance, withLocation: userLocation)
    }

    ///Проверяет есть ли данные в БД Realm
    ///
    /// - Returns:
    ///     `true` - если данные есть. `false` - если данных нет
    func checkDataInRealm() -> Bool {
        guard let realmAtms = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .AtmConfiguration)) else {
            print("Не удалось подключиться к БД Realm ATMDataConfiguration")
            return false
        }

        return realmAtms.isEmpty
    }
}

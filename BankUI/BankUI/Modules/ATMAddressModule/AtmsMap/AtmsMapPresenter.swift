//
//  AtmsMapPresenter.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 11.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import CoreLocation

protocol AtmsMapPresenterProtocol: class {
    func getClasteredAtms(for cluster: AtmsClastarizationByDistance, shouldUpdate: Bool, completion: @escaping (Int) -> Void)
    func getAtmsList(completion: @escaping (Int) -> Void)
    func getAtmsListCount() -> Int
    func getClasterizedAtms() -> OrderedDictionary<AtmLocationModel, [ATMMapModelProtocol]>
    func getAtmsInfo(byLatitide latitude: Double, byLongitude longitude: Double) -> ATMMapModelProtocol?
    func getAtmsInfo(forIndex index: Int) -> ATMMapModelProtocol
    func showDetailInfo(forLatitude latitude: Double, forLongitude longitude: Double) -> [ATMMapModelProtocol]
}

class AtmsMapPresenter {

    // MARK: - Свойства

     weak var view: AtmsMapVCProtocol?
     var interactor: AtmsMapInteractorProtocol?
     var router: AtmsMapRouterProtocol?

    private let maxDistance: Double = 5
    private var userLocation: CLLocation = CLLocation(latitude: 55.695811, longitude: 37.662665) //Координаты райфа

    ///Отсортированные по близости к пользователю банковские продукты и отделения
    var sortedByDistanceATMs: [ATMMapModelProtocol] = []

    ///Количество банковских продуктов и отделений в текущей местности
//    var clasteredATMs: [AtmLocationModel : [ATMMapModelProtocol]] = [:]
    var orderedClasteredATMs = OrderedDictionary<AtmLocationModel, [ATMMapModelProtocol]>()

    ///Список отделений и банковских продуктов, которые находятся в дном месте
    var atmsWithSimilarLocations: [AtmLocationModel: [ATMMapModelProtocol]] = [:]

    required init (view: AtmsMapVCProtocol) {
        self.view = view
    }

    private func clasterizedAtms(for distance: Double) {
        orderedClasteredATMs = OrderedDictionary<AtmLocationModel, [ATMMapModelProtocol]>()
        var midLatitude: Double = 0
        var midLongutude: Double = 0
        var index = 0
        var count = 0
        var atmLocation: AtmLocationModel!

        while index < sortedByDistanceATMs.count {
            guard let location = try? GeoLocation(degLatitude: sortedByDistanceATMs[index].latitude, degLongitude: sortedByDistanceATMs[index].longitude) else {
                print("Не удалось установить местоположение пользователя")
                return
            }

            for atm in orderedClasteredATMs.keys {
                let distanceToAtm = RealmQueriesHelper.calculateDistance(from: location, to: CLLocation(latitude: atm.latitude, longitude: atm.longitude))
                if distanceToAtm < distance {
                    atmLocation = AtmLocationModel(latitude: atm.latitude, longitude: atm.longitude)
                    count += 1
                    midLatitude = (atm.latitude + location.degLatitude) / 2.0
                    midLongutude = (atm.longitude + location.degLongitude) / 2.0
                    break
                }
            }

            if count == 0 {
                atmLocation = AtmLocationModel(latitude: sortedByDistanceATMs[index].latitude, longitude: sortedByDistanceATMs[index].longitude)
            }
            if orderedClasteredATMs[atmLocation] == nil {
                orderedClasteredATMs[atmLocation] = [sortedByDistanceATMs[index]]
            } else {
                var atms = orderedClasteredATMs[atmLocation]!
                orderedClasteredATMs[atmLocation] = nil
                atmLocation = AtmLocationModel(latitude: midLatitude, longitude: midLongutude)
                atms.append(sortedByDistanceATMs[index])
                orderedClasteredATMs[atmLocation] = atms
                count = 0
            }

            index += 1
        }
        checkClasteredObjects(for: distance)
    }

    //Пытаемся склеить уже сгруппированные отделения расположенные поблизости между друг другом в одно
    private func checkClasteredObjects(for distance: Double) {

        var midLatitude: Double = 0
        var midLongutude: Double = 0
        var index = 0

        //Проходим по всей коллекции начиная с 0
        while index < orderedClasteredATMs.count {
            guard let location = try? GeoLocation(degLatitude: orderedClasteredATMs.keys[index].latitude, degLongitude: orderedClasteredATMs.keys[index].longitude) else {
                print("Не удалось установить местоположение пользователя")
                return
            }

            //Здесь проходим по всей коллекции кроме элемента, который выбран в цикле выше
            for i in 0..<orderedClasteredATMs.count {
                if i>=orderedClasteredATMs.count {
                    break
                }
                if i == index {
                    continue
                }
                let distanceToAtm = RealmQueriesHelper.calculateDistance(from: location, to: CLLocation(latitude: orderedClasteredATMs.keys[i].latitude, longitude: orderedClasteredATMs.keys[i].longitude))
                if distanceToAtm < distance {
                    //Берем координаты подходящей группы
                    var atmLocation = AtmLocationModel(latitude: orderedClasteredATMs.keys[i].latitude, longitude: orderedClasteredATMs.keys[i].longitude)
                    //Берем координаты той группы относительно который ищем ближайшие
                    let parentLocation = AtmLocationModel(latitude: orderedClasteredATMs.keys[index].latitude, longitude: orderedClasteredATMs.keys[index].longitude)
                    //Считаем средние коорданиты двух групп
                    midLatitude = (orderedClasteredATMs.keys[i].latitude + location.degLatitude) / 2.0
                    midLongutude = (orderedClasteredATMs.keys[i].longitude + location.degLongitude) / 2.0
                    //Получаем данные о банкоматах
                    var atms = orderedClasteredATMs[parentLocation]!
                    //Соединаяем данные о банкоматах из двух групп
                    atms.append(contentsOf: orderedClasteredATMs.values[atmLocation]!)
                    //Удаляем записи о них из коллекции
                    orderedClasteredATMs[atmLocation] = nil
                    orderedClasteredATMs[parentLocation] = nil
                    atmLocation = AtmLocationModel(latitude: midLatitude, longitude: midLongutude)
                    if index > orderedClasteredATMs.count {
                        orderedClasteredATMs.insert(at: 0, key: atmLocation, value: atms)
                    }
                    //Добавляем в коллекцию сгруппированные данные по новым усредненным координатам
                    orderedClasteredATMs.insert(at: index, key: atmLocation, value: atms)
                }
            }
            index += 1
        }
    }
}

extension AtmsMapPresenter: AtmsMapPresenterProtocol {

    ///Загружает необходимый список отделений и банкоматов из сети или если они есть из БД Realm
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда все операции закончат свое выполнение
    func getAtmsList(completion: @escaping (Int) -> Void) {
        guard let interactor = interactor else { return }

        if interactor.checkDataInRealm() {
            //Ждем когда данные загрузятся
            print("Данные загружаются")
            completion(0)
        } else {
            print("Данные о метро уже в памяти")
            let filters = UserData.getFilters()
            sortedByDistanceATMs = interactor.loadAtmsListFromRealm(with: [(filters[0], 1), (filters[1], 3), (filters[2], 102)], with: maxDistance, withLocation: userLocation)

            //Сюда мы попадаем только если запрос с пользовательскими фильтрами вернул 0
            if sortedByDistanceATMs.count == 0 {
                print("Нету данных удовлетворяющих запросу")
                completion(0)
                return
            } else {
                completion(sortedByDistanceATMs.count)
            }
        }
    }

    func getClasteredAtms(for cluster: AtmsClastarizationByDistance, shouldUpdate: Bool, completion: @escaping (Int) -> Void) {

        if shouldUpdate {
            print(cluster.distanceDelta)
            getAtmsList(completion: completion)
            clasterizedAtms(for: cluster.distanceDelta)
        } else {
            print(cluster.distanceDelta)
            clasterizedAtms(for: cluster.distanceDelta)
            completion(sortedByDistanceATMs.count)
        }
    }

    ///Возвращает количество полученных из БД записей о банковских продуктах
    ///
    /// - Returns:
    ///     Количество полученных из БД записей
    func getAtmsListCount() -> Int {
        return sortedByDistanceATMs.count
    }

    func getClasterizedAtms() -> OrderedDictionary<AtmLocationModel, [ATMMapModelProtocol]> {
        return orderedClasteredATMs
    }

    func getAtmsInfo(byLatitide latitude: Double, byLongitude longitude: Double) -> ATMMapModelProtocol? {
        return sortedByDistanceATMs.first { (atm) -> Bool in
            return atm.latitude == latitude && atm.longitude == longitude
        }
    }

    ///Возвращает объект содержащий необходимую информацию о продукте
    ///
    /// - Parameters:
    ///     - index: Индекс интересующего элемента
    /// - Returns:
    ///     Запрашиваемая модель
    func getAtmsInfo(forIndex index: Int) -> ATMMapModelProtocol {
        return sortedByDistanceATMs[index]
    }

    ///Открывает карточки с детальной информацией о банковском продукте
    func showDetailInfo(forLatitude latitude: Double, forLongitude longitude: Double) -> [ATMMapModelProtocol] {
//        guard let view = view else { return }
        guard let atms = orderedClasteredATMs[AtmLocationModel(latitude: latitude, longitude: longitude)] else { return []}

        return atms
    }
}

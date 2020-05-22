//
//  SubwayListInteractor.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

protocol SubwayListInteractorProtocol {
    func loadSubwaysListFromRealm(with filters: [(Bool, Int)], with distance: Double, withLocation userLocation: CLLocation) -> [SubwayListModelProtocol]
    func checkDataInRealm() -> Bool
}

class SubwayListInteractor {

    // MARK: - Свойства

    weak var presenter: SubwayListPresenterProtocol?

    private let networkDataFetcher: NetworkDataFetcher

    required init (presenter: SubwayListPresenterProtocol) {
        self.presenter = presenter
        self.networkDataFetcher = NetworkDataFetcher(networking: NetworkService())
    }

}

extension SubwayListInteractor: SubwayListInteractorProtocol {

    ///Загружает список метро, которые находятся не дальше чем `distance` от `userLocation` и количество банковских продуктов рядом с этим метро.
    ///
    /// - Parameters:
    ///     - filters: Массив фильтров банковских продуктов, установленных пользователем
    ///     - distance: Максимальное расстояние до искомых Банковских продуктов (Указывается в километрах)
    ///     - userLocation: Текущее местоположение пользователя
    /// - Returns:
    ///     Возвращаеет массив объектов удовлетворяющих запросу пользователя
    func loadSubwaysListFromRealm(with filters: [(Bool, Int)], with distance: Double, withLocation userLocation: CLLocation) -> [SubwayListModelProtocol] {
        guard let realmSubways = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .subwayConfiguration)) else {
            print("Не удалось подключиться к БД Realm subwaysDataConfiguration")
            return []
        }

        guard let userLocation = try? GeoLocation(degLatitude: userLocation.coordinate.latitude, degLongitude: userLocation.coordinate.longitude) else {
            print("Не удалось установить местоположение пользователя")
            return []
        }

        guard let boundBox = try? userLocation.boundingCoordinates(distance) else {
            print("Не удалось установить границы поиска")
            return []
        }

        //Фильтруем данные из БД в соответствии с ограничивающей расстоянием рамкой, заданными фильтрами, и сортируем по близости
        let result = realmSubways.objects(RealmSubwayList.self).filter("latitude <= \(boundBox.1.degLatitude) AND latitude >= \(boundBox.0.degLatitude) AND longitude <= \(boundBox.1.degLongitude) AND longitude >= \(boundBox.0.degLongitude)").sorted(byKeyPath: "name")

        guard let realmAtms = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .AtmConfiguration)) else {
            print("Не удалось подключиться к БД Realm ATMDataConfiguration")
            return []
        }

        let str = RealmQueriesHelper.getFilterString(filters)
        var subwayList: [SubwayListModelProtocol] = []

        for subway in result {

            //Считаем расстояние до метро от пользователя
            let distanceToSubway = RealmQueriesHelper.calculateDistance(from: userLocation, to: CLLocation(latitude: subway.latitude, longitude: subway.longitude))

            //Так как из БД нам пришли все координаты которые помещаются в квадрат (boundBox), а нам нужен круг с радиусом в distance
            //То проверяем что расстояние до точки меньше чем искомое
            if distanceToSubway < distance {
                //Получаем банкоматы у которых есть id текущего метро
                var atmsResult = realmAtms.objects(RealmATMList.self).filter(str).filter { (atm) -> Bool in
                    if atm.subwayIds.count > 0 {
                        if atm.subwayIds.contains(String(subway.id)) {
                            return true
                        }
                    }
                    return false
                    }.sorted(by: { (atmFirst, atmSecond) -> Bool in
                    let atmFirstDistance = RealmQueriesHelper.calculateDistance(from: userLocation, to: CLLocation(latitude: atmFirst.latitude, longitude: atmFirst.longitude))
                    let atmSecondDistance = RealmQueriesHelper.calculateDistance(from: userLocation, to: CLLocation(latitude: atmSecond.latitude, longitude: atmSecond.longitude))

                    return atmFirstDistance < atmSecondDistance
                })
                //Теперь отфильтровываем только те продукты банка, которые находятся на допустимом расстоянии
                atmsResult = atmsResult.filter { (atm) -> Bool in
                    return RealmQueriesHelper.calculateDistance(from: userLocation, to: CLLocation(latitude: atm.latitude, longitude: atm.longitude)) < distance
                }
                //Если есть метро
                if var firstAtm = atmsResult.first {

                    //То уже будет как миниум один банковский продукт удовлетворяющий поиску
                    var count = 1
                    //Идем по циклу начиная с 1, так как нулевой элемент мы уже получили
                    for i in 1..<atmsResult.count {
                        //Если из БД вернулось отделение банка у которого одинаковые данные с предыдущим, то мы его не будем добавлять в список
                        if firstAtm.addressFull == atmsResult[i].addressFull && firstAtm.workTime == atmsResult[i].workTime && firstAtm.typeId == atmsResult[i].typeId {
                            firstAtm = atmsResult[i]
                            continue
                        }
                        //Если данные разные, то такой банковский продукт мы учитываем
                        firstAtm = atmsResult[i]
                        count += 1
                    }
                    subwayList.append(SubwayListModel(id: String(subway.id), name: subway.name, color: subway.colour, countOfAtms: count))
                }
            }
        }

        return subwayList
    }

    ///Проверяет есть ли данные в БД Realm
    ///
    /// - Returns:
    ///     `true` - если данные есть. `false` - если данных нет
    func checkDataInRealm() -> Bool {
        guard let realmSubways = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .subwayConfiguration)) else {
            print("Не удалось подключиться к БД Realm subwaysDataConfiguration")
            return false
        }

        return realmSubways.isEmpty
    }

}

//
//  ATMListInteractor.swift
//  BankUI
//
//  Created by Lev Kolesnikov on 21.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

protocol ATMListInteractorProtocol {
    func loadAtmsListFromRealm(with filters: [(Bool, Int)], with distance: Double, withLocation userLocation: CLLocation) -> [ATMListModelProtocol]
    func loadAtmsForSubwayFromRealm(for subway: SubwayListModelProtocol, with filters: [(Bool, Int)], with distance: Double, withLocation userLocation: CLLocation) -> [ATMListModelProtocol]
    func loadAtmsData(completion: @escaping (Result<Int, LoadATMsAndSubwaysError>) -> Void)
    func loadSubwayData(completion: @escaping (Result<Int, LoadATMsAndSubwaysError>) -> Void)
    func checkDataInRealm() -> Bool
}

class ATMListInteractor {

    // MARK: - Свойства

    weak var presenter: ATMListPresenterProtocol?

    var atms: Results<RealmATMList>?

    private let networkDataFetcher: NetworkDataFetcher

    required init (presenter: ATMListPresenterProtocol) {
        self.presenter = presenter
        self.networkDataFetcher = NetworkDataFetcher(networking: NetworkService())
    }
}

extension ATMListInteractor: ATMListInteractorProtocol {

    ///Загружает данные о банкоматах и отделениях из интернета и записывает данные в БД Realm
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда все операции закончат свое выполнение
    func loadAtmsData(completion: @escaping (Result<Int, LoadATMsAndSubwaysError>) -> Void) {
        networkDataFetcher.getATMPoints(completion: completion)
    }

    ///Загружает данные о станциях метро из интернета и записывает данные в БД Realm
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда все операции закончат свое выполнение
    func loadSubwayData(completion: @escaping (Result<Int, LoadATMsAndSubwaysError>) -> Void) {
        networkDataFetcher.getSubwayPoints(completion: completion)
    }

    ///Загружает список Банкоматов, Отделений и Терминалов из БД, которые находятся не дальше чем `distance` от `userLocation`.
    ///
    /// - Parameters:
    ///     - filters: Массив фильтров банковских продуктов, установленных пользователем
    ///     - distance: Максимальное расстояние до искомых Банковских продуктов (Указывается в километрах)
    ///     - userLocation: Текущее местоположение пользователя
    /// - Returns:
    ///     Возвращаеет массив объектов удовлетворяющих запросу пользователя
    func loadAtmsListFromRealm(with filters: [(Bool, Int)], with distance: Double, withLocation userLocation: CLLocation) -> [ATMListModelProtocol] {

        guard let realmAtms = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .AtmConfiguration)) else {
            print("Не удалось подключиться к БД Realm ATMDataConfiguration")
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

        let str = RealmQueriesHelper.getFilterString(filters)
        //Фильтруем данные из БД в соответствии с ограничивающей расстоянием рамкой, заданными фильтрами, и сортируем по близости
        let result = realmAtms.objects(RealmATMList.self).filter("latitude <= \(boundBox.1.degLatitude) AND latitude >= \(boundBox.0.degLatitude) AND longitude <= \(boundBox.1.degLongitude) AND longitude >= \(boundBox.0.degLongitude)").filter(str).sorted(by: { (atmFirst, atmSecond) -> Bool in
            let atmFirstDistance = RealmQueriesHelper.calculateDistance(from: userLocation, to: CLLocation(latitude: atmFirst.latitude, longitude: atmFirst.longitude))
            let atmSecondDistance = RealmQueriesHelper.calculateDistance(from: userLocation, to: CLLocation(latitude: atmSecond.latitude, longitude: atmSecond.longitude))

            return atmFirstDistance < atmSecondDistance
        })

        guard let realmSubways = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .subwayConfiguration)) else {
            print("Не удалось подключиться к БД Realm subwaysDataConfiguration")
            return []
        }

        var atmList: [ATMListModelProtocol] = []

        //Записываем расстояние до найденного банковского продукта в новый объект для отображения данных
        for atm in result {
            if let atmList = atmList.last {
                if atmList.addressFull == atm.addressFull && atmList.typeId == atm.typeId {
                    continue
                }
            }
            //Считаем расстояние до продукта банка от пользователя
            let distanceToAtm = RealmQueriesHelper.calculateDistance(from: userLocation, to: CLLocation(latitude: atm.latitude, longitude: atm.longitude))
            //Так как из БД нам пришли все координаты которые помещаются в квадрат (boundBox), а нам нужен круг с радиусом в distance
            //То проверяем что расстояние до точки меньше чем искомое
            if distanceToAtm < distance {
                //Записываем ближайшие станции метро для банковского продукта
                var subwaysIds: [SubwaysListForAtmsModelProtocol]? = atm.subwayIds.count > 0 ? [] : nil
                for subway in atm.subwayIds {
                    if let subwayId = subway {
                        //Получаем объект станции метро из БД по интересующему нас id
                        let subway = realmSubways.objects(RealmSubwayList.self).filter("id == \(subwayId)")
                        if let subwayObject = subway.first {
                            //Упаковываем необходимые нам данные о метро
                            subwaysIds?.append(SubwaysListForAtmsModel(name: subwayObject.name, color: subwayObject.colour))
                        }
                    }
                }
                atmList.append(ATMListModel(typeId: atm.typeId, bankName: atm.bankName, workTime: atm.workTime, addressFull: atm.addressFull, subwayIds: subwaysIds, distanceToCurrentUser: Int(distanceToAtm * 1000)))
            }
        }

        return atmList
    }

    func loadAtmsForSubwayFromRealm(for subway: SubwayListModelProtocol, with filters: [(Bool, Int)], with distance: Double, withLocation userLocation: CLLocation) -> [ATMListModelProtocol] {

        guard let realmAtms = try? Realm(configuration: RealmConfigurator.getRealmConfiguration(configurationName: .AtmConfiguration)) else {
            print("Не удалось подключиться к БД Realm ATMDataConfiguration")
            return []
        }

        guard let userLocation = try? GeoLocation(degLatitude: userLocation.coordinate.latitude, degLongitude: userLocation.coordinate.longitude) else {
            print("Не удалось установить местоположение пользователя")
            return []
        }

        let str = RealmQueriesHelper.getFilterString(filters)
        let result = realmAtms.objects(RealmATMList.self).filter(str).filter { (atm) -> Bool in
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

        var atmList: [ATMListModelProtocol] = []

        for atm in result {
            if let atmList = atmList.last {
                if atmList.addressFull == atm.addressFull && atmList.workTime == atm.workTime && atmList.typeId == atm.typeId {
                    continue
                }
            }
            //Считаем расстояние до продукта банка от пользователя
            let distanceToAtm = RealmQueriesHelper.calculateDistance(from: userLocation, to: CLLocation(latitude: atm.latitude, longitude: atm.longitude))
            //Так как из БД нам пришли все координаты которые помещаются в квадрат (boundBox), а нам нужен круг с радиусом в distance
            //То проверяем что расстояние до точки меньше чем искомое
            if distanceToAtm < distance {

                atmList.append(ATMListModel(typeId: atm.typeId, bankName: atm.bankName, workTime: atm.workTime, addressFull: atm.addressFull, subwayIds: [SubwaysListForAtmsModel(name: subway.name, color: subway.color)], distanceToCurrentUser: Int(distanceToAtm * 1000)))
            }
        }

        return atmList
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

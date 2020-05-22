//
//  RealmQueriesHelper.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 04.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class RealmQueriesHelper {

    ///Возвращает строку фильтрации для запроса в БД на основе установленных пользователем фильтров `filters`
    ///
    /// - Parameters:
    ///     - filters: Массив значений фильтров, где первый элемент кортежа - значение галочки, а второе это тип соответствующий значению фильтра в БД
    /// - Returns:
    ///     Возвращает строку которая соответствует запросу в БД на основе переданных значений фильтров
    static func getFilterString(_ filters: [(Bool, Int)]) -> String {

        var str: String = ""

        for i in 0..<filters.count {
            if filters[i].0 {
                str += "typeId == \(filters[i].1) OR "
            } else {
                str += "typeId == \(0) OR "
            }
        }

        //Удаляем из строки ненужные последние символы (" AND ")
        str.removeLast(4)
        return str
    }

    ///Считает расстояние от пользователя до точки
    ///
    /// - Parameters:
    ///     - userLocation: Местоположение пользователя
    ///     - location: Местоположение точки до которой считаем расстояние
    /// - Returns:
    ///     Растояние от пользователя до искомой точки (в километрах)
    static func calculateDistance(from userLocation: GeoLocation, to location: CLLocation) -> Double {
        if let location = try? GeoLocation(degLatitude: location.coordinate.latitude, degLongitude: location.coordinate.longitude) {
            return userLocation.distanceTo(location)
        }
        return 0
    }

    ///Загружает список Банкоматов, Отделений и Терминалов из БД, которые находятся не дальше чем distance от userLocation.
    ///
    /// - Parameters:
    ///     - filters: Массив фильтров банковских продуктов, установленных пользователем
    ///     - distance: Максимальное расстояние до искомых Банковских продуктов (Указывается в километрах)
    ///     - userLocation: Текущее местоположение пользователя
    /// - Returns:
    ///     Возвращаеет массив объектов удовлетворяющих запросу пользователя
    static func loadAllAtmsTypeWithFIltersAndUserPosition(with filters: [(Bool, Int)], with distance: Double, withLocation userLocation: CLLocation) -> [ATMMapModelProtocol] {
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

        var atmList: [ATMMapModelProtocol] = []

        //Записываем расстояние до найденного банковского продукта в новый объект для отображения данных
        for atm in result {
            if let atmList = atmList.last {
                if atmList.addressFull == atm.addressFull && atmList.typeId == atm.typeId && atmList.workTime == atm.workTime {
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
                //                if atmList.contains(where: { (atmModel) -> Bool in
                //                    return atmModel.latitude == atm.latitude && atmModel.longitude == atm.longitude
                //                }) {
                //                    atmList.append(ATMMapModel(typeId: atm.typeId, latitude: atm.latitude + 0.0005, longitude: atm.longitude + 0.0005, bankName: atm.bankName, workTime: atm.workTime, addressFull: atm.addressFull, subwayIds: subwaysIds, distanceToCurrentUser: Int(distanceToAtm * 1000)))
                //                }
                //                else {
                //                    atmList.append(ATMMapModel(typeId: atm.typeId, latitude: atm.latitude, longitude: atm.longitude, bankName: atm.bankName, workTime: atm.workTime, addressFull: atm.addressFull, subwayIds: subwaysIds, distanceToCurrentUser: Int(distanceToAtm * 1000)))
                //                }
                atmList.append(ATMMapModel(typeId: atm.typeId, latitude: atm.latitude, longitude: atm.longitude, bankName: atm.bankName, workTime: atm.workTime, addressFull: atm.addressFull, subwayIds: subwaysIds, distanceToCurrentUser: Int(distanceToAtm * 1000)))
            }
        }

        return atmList
    }
}

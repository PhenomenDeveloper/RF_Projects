//
//  GeoLocationService.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 21.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

class GeoLocation {

    enum GeoLocationError: Error {
        case invalidBound
        case invalidArgument
        case nilValue
    }

    let radLatitude: Double
    let radLongitude: Double
    let degLatitude: Double
    let degLongitude: Double

    let MinLatitude = -90.degreesToRadians // -PI/2
    let MaxLatitude = 90.degreesToRadians  // PI/2
    let MinLongitude = -180.degreesToRadians   // -PI
    let MaxLongitude = 180.degreesToRadians    // PI

    let earthRadius = 6371.01

    ///Инициализатор для значение широты и долготы в градусах
    init(degLatitude: Double, degLongitude: Double) throws {
        self.radLatitude = degLatitude.degreesToRadians
        self.radLongitude = degLongitude.degreesToRadians
        self.degLatitude = degLatitude
        self.degLongitude = degLongitude

        try self.checkBounds()
    }

    ///Инициализатор для значение широты и долготы в радианах
    init(radLatitude: Double, radLongitude: Double) throws {
        self.radLatitude = radLatitude
        self.radLongitude = radLongitude
        self.degLatitude = radLatitude.radiansToDegrees
        self.degLongitude = radLongitude.radiansToDegrees

        try self.checkBounds()
    }

    ///Возвращает координаты точки из значений широты и долготы в градусах
    ///
    /// - Parameters:
    ///     - latitude: Широта
    ///     - longitude: долгота
    /// - Returns:
    ///     Координаты точки
    class func fromDegrees(_ latitude: Double, _ longitude: Double) -> GeoLocation? {
        guard let result = try? GeoLocation(degLatitude: latitude, degLongitude: longitude) else {
            return nil
        }
        return result
    }

    ///Возвращает координаты точки из значений широты и долготы в радианах
    ///
    /// - Parameters:
    ///     - latitude: Широта
    ///     - longitude: долгота
    /// - Returns:
    ///     Координаты точки
    class func fromRadians(_ latitude: Double, longitude: Double) -> GeoLocation? {
        guard let result = try? GeoLocation(radLatitude: latitude, radLongitude: longitude) else {
            return nil
        }
        return result
    }

    fileprivate func checkBounds() throws {
        if radLatitude < MinLatitude || radLatitude > MaxLatitude || radLongitude < MinLongitude || radLongitude > MaxLongitude {
            throw GeoLocationError.invalidBound
        }
    }

    ///Описание экземпляра местоположения в градусах и радианах
    var description: String {
        return "\(String(describing: degLatitude))°, \(String(describing: degLongitude))° = \(String(describing: radLatitude)) rad, \(String(describing: radLongitude)) rad"
    }

    ///Вычисляет расстояние от заданной точки до точки `location`
    ///
    /// - Parameters:
    ///     - location: Точка до которой рассчитывается расстояние
    /// - Returns:
    ///     Расстояние между точками. (Измеряется в километрах)
    func distanceTo(_ location: GeoLocation) -> Double {
        return acos(sin(radLatitude) * sin(location.radLatitude) +
            cos(radLatitude) * cos(location.radLatitude) *
            cos(radLongitude - location.radLongitude)) * earthRadius
    }

    ///Возвращает минимальную и максимальную широту и долготу относительно центральной точки, которые расположены на расстоянии `distance`
    ///
    /// - Parameters:
    ///     - distance: Дистанция от заданной точки до искомых координат (Измеряется в киллометрах)
    /// - Returns:
    ///     Возвращает кортеж минимальной широты и долготы и кортеж максимальной широты и долготы
    func boundingCoordinates(_ distance: Double) throws -> (GeoLocation, GeoLocation) {
        if distance < 0.0 {
            throw GeoLocationError.invalidArgument
        }

        let radDist = distance / earthRadius

        var minLat: Double = radLatitude - radDist
        var maxLat: Double = radLatitude + radDist

        var minLon: Double, maxLon: Double

        if minLat > MinLatitude && maxLat < MaxLatitude {
            let deltaLon = asin(sin(radDist) / cos(radLatitude))
            minLon = radLongitude - deltaLon

            if minLon < MinLongitude { minLon += 2 * .pi }
            maxLon = radLongitude + deltaLon
            if maxLon > MaxLongitude { maxLon -= 2 * .pi }
        } else {
            minLat = max(minLat, MinLatitude)
            maxLat = min(maxLat, MaxLatitude)
            minLon = MinLongitude
            maxLon = MaxLongitude
        }

        if let location1 = GeoLocation.fromRadians(minLat, longitude: minLon),
            let location2 = GeoLocation.fromRadians(maxLat, longitude: maxLon) {
            return (location1, location2)
        } else {
            throw GeoLocationError.nilValue
        }
    }
}

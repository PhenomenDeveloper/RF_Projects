//
//  SubwayListPresenter.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

protocol SubwayListPresenterProtocol: class {
    func getSubwayList(completion: @escaping (String) -> Void)
    func getSubwaysKeysCount() -> Int
    func getOrderedSubways(at index: Int) -> Character
    func getSubwaysCount(forKey key: Character) -> Int
    func getSubwaysList(forKey key: Character) -> [SubwayListModelProtocol]
    func getSubwaysCount() -> Int
    func goToAtmsWithChoosenSubway(section: Int, index: Int)
}

class SubwayListPresenter {

    // MARK: - Свойства

    weak var view: SubwayListVCProtocol?
    var interactor: SubwayListInteractorProtocol?
    var router: SubwayListRouterProtocol?

    // Данные из БД
    var sortedByDistanceSubways: [Character: [SubwayListModelProtocol]] = [:]
    var orderedLetters: [Character] = []

    // Координаты Райфа
    private let maxDistance: Double = 5
    private var userLocation: CLLocation = CLLocation(latitude: 55.695811, longitude: 37.662665)

    required init (view: SubwayListVCProtocol) {
        self.view = view
    }

    private func orderSubwaysByLetters(subways: [SubwayListModelProtocol]) {

        sortedByDistanceSubways = [:]
        orderedLetters = []
        //Заполняем уникальными датами
        for subway in subways {
            let letter = subway.name.first
            guard let firstLetter = letter else { return }
            sortedByDistanceSubways[firstLetter] = []
        }
        self.orderedLetters = sortedByDistanceSubways.keys.sorted(by: <)

        for subway in subways {
            let letter = subway.name.first
            guard let firstLetter = letter else { return }
            sortedByDistanceSubways[firstLetter]?.append(subway)
        }
    }
}

extension SubwayListPresenter: SubwayListPresenterProtocol {

    ///Загружает необходимый список метро если они есть из БД Realm
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда все операции закончат свое выполнение
    func getSubwayList(completion: @escaping (String) -> Void) {

        guard let interactor = interactor else { return }

        if interactor.checkDataInRealm() {
            //Ждем когда данные загрузятся
            print("Данные о метро загружаются")
            completion("Данные о метро загружаются. Попробуйте обновить список")
        } else {
            print("Данные о метро уже в памяти")
            let filters = UserData.getFilters()
            orderSubwaysByLetters(subways: interactor.loadSubwaysListFromRealm(with: [(filters[0], 1), (filters[1], 3), (filters[2], 102)], with: maxDistance, withLocation: userLocation))

            //Сюда мы попадаем только если запрос с пользовательскими фильтрами вернул 0
            if sortedByDistanceSubways.count == 0 {
                print("Нету данных удовлетворяющих запросу")
                completion("Нету данных удовлетворяющих запросу")
                return
            } else {
                completion("")
            }
        }
    }

    ///Возвращает букву по индексу из отсортированного по алфавиту массива
    ///
    /// - Parameters:
    ///     - index: Индекс необходимой буквы
    /// - Returns:
    ///     Возвращает символ этой буквы
    func getOrderedSubways(at index: Int) -> Character {
        return orderedLetters[index]
    }

    ///Возвращает список станций метро начинающиеся с заданной буквы `key`
    ///
    /// - Parameters:
    ///     - key: Относительно этой буквы вернется количество станций
    /// - Returns:
    ///     Список метро
    func getSubwaysList(forKey key: Character) -> [SubwayListModelProtocol] {
        guard let subways = sortedByDistanceSubways[key] else { return [] }

        return subways
    }

    ///Возвращает количество полученных из БД записей о станциях метро
    ///
    /// - Returns:
    ///     Количество полученных из БД записей
    func getSubwaysKeysCount() -> Int {
        return sortedByDistanceSubways.keys.count
    }

    ///Возвращает количество станций метро начинающиеся с заданной буквы `key`
    ///
    /// - Parameters:
    ///     - key: Относительно этой буквы вернется количество станций
    /// - Returns:
    ///     Количество станций, имя которых начинается с определенной буквы
    func getSubwaysCount(forKey key: Character) -> Int {

        guard let values = sortedByDistanceSubways[key] else { return 0 }

        return values.count
    }

    ///Возвращает количество станций метро
    ///
    /// - Returns:
    ///     Количество полученных из БД записей о метро
    func getSubwaysCount() -> Int {
        return sortedByDistanceSubways.count
    }

    func goToAtmsWithChoosenSubway(section: Int, index: Int) {
        guard let subway = sortedByDistanceSubways[orderedLetters[section]]?[index],
              let view = view else { return }
        router?.showAtmsWithChoosenSubway(with: subway, from: view)
    }
}

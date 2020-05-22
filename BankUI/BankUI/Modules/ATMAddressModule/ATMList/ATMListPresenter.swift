//
//  ATMListPresenter.swift
//  BankUI
//
//  Created by Lev Kolesnikov on 21.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

protocol ATMListPresenterProtocol: class {
    func getAtmsList(completion: @escaping (Int) -> Void)
    func getAtmsForSubway(subway: SubwayListModelProtocol, completion: @escaping (Int) -> Void)
    func getAtmsListCount() -> Int
    func getAtmsInfo(forIndex index: Int) -> ATMListModelProtocol
    func showDetailInfo(for index: Int)
}

class ATMListPresenter {

    // MARK: - Свойства

    weak var view: ATMListVCProtocol?
    var interactor: ATMListInteractorProtocol?
    var router: ATMListRouterProtocol?

    private let maxDistance: Double = 5
    private var userLocation: CLLocation = CLLocation(latitude: 55.695811, longitude: 37.662665) //Координаты райфа

    //данные из бд
    var sortedByDistanceATMs: [ATMListModelProtocol] = []
    var subways: [Results<RealmSubwayList>?] = []

    required init (view: ATMListVCProtocol) {
        self.view = view
    }

}

extension ATMListPresenter: ATMListPresenterProtocol {

    ///Загружает необходимый список отделений и банкоматов из сети или если они есть из БД Realm
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда все операции закончат свое выполнение
    func getAtmsList(completion: @escaping (Int) -> Void) {

        guard let interactor = interactor else { return }
        if interactor.checkDataInRealm() {
            //Загружаем информацию о Банкоматах и отделениях
            interactor.loadAtmsData {[weak self] (result) in
                switch result {
                case .success:
                    print("Загрузка и запись списка отделений банка прошла успешно")

                    //Загружаем информацию о станциях метро
                    interactor.loadSubwayData { (result) in
                        switch result {
                        case .success:
                            print("Загрузка и запись информации о метро прошла успешно")
                            OperationQueue.main.addOperation {
                                guard let distance = self?.maxDistance,
                                      let userLocation = self?.userLocation else {return}

                                let filters = UserData.getFilters()
                                let loadedAtmsFromRealm = interactor.loadAtmsListFromRealm(with: [(filters[0], 1), (filters[1], 3), (filters[2], 102)], with: distance, withLocation: userLocation)
                                self?.sortedByDistanceATMs = loadedAtmsFromRealm
                                completion(loadedAtmsFromRealm.count)
                            }
                        case .failure(let error):
                            print("Ошибка - \(error.localizedDescription)")
                        }
                    }

                case .failure(let error):
                    print("Ошибка - \(error.localizedDescription)")
                }
            }
        } else {
            print("Необходимые данные о банкоматах и метро уже находятся в памяти устройства")
            let filters = UserData.getFilters()
            sortedByDistanceATMs = interactor.loadAtmsListFromRealm(with: [(filters[0], 1), (filters[1], 3), (filters[2], 102)], with: maxDistance, withLocation: userLocation)
            if sortedByDistanceATMs.count == 0 {
                print("Нету данных удовлетворяющих запросу")
                completion(0)
            } else {
                completion(sortedByDistanceATMs.count)
            }
        }
    }

    func getAtmsForSubway(subway: SubwayListModelProtocol, completion: @escaping (Int) -> Void) {
        guard let interactor = interactor else { return }
        let filters = UserData.getFilters()
        sortedByDistanceATMs = interactor.loadAtmsForSubwayFromRealm(for: subway, with: [(filters[0], 1), (filters[1], 3), (filters[2], 102)], with: maxDistance, withLocation: userLocation)
        if sortedByDistanceATMs.count == 0 {
            print("Нету данных удовлетворяющих запросу")
            completion(0)
        } else {
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

    ///Возвращает объект содержащий необходимую информацию о продукте
    ///
    /// - Parameters:
    ///     - index: Индекс интересующего элемента
    /// - Returns:
    ///     Запрашиваемая модель
    func getAtmsInfo(forIndex index: Int) -> ATMListModelProtocol {
        return sortedByDistanceATMs[index]
    }

    ///Открывает карточки с детальной информацией о банковском продукте
    func showDetailInfo(for index: Int) {
        guard let view = view else { return }
        router?.showBottomCard(with: sortedByDistanceATMs[index], from: view)
    }
}

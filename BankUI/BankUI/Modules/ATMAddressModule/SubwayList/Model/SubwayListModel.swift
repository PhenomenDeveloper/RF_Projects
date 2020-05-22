//
//  SubwayListModel.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 03.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol SubwayListModelProtocol {
    var id: String { get }
    var name: String { get }
    var color: String { get }
    var countOfAtms: Int { get }
}

struct SubwayListModel: SubwayListModelProtocol {
    ///ID метро в БД
    var id: String
    ///Имя метро
    var name: String
    ///Цвет ветки метро
    var color: String
    ///Количество отделений банка рядом с метро
    var countOfAtms: Int
}

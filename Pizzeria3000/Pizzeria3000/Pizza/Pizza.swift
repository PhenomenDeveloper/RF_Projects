//
//  Pizza.swift
//  Pizzeria3000
//
//  Created by Lev Kolesnikov on 24.11.2019.
//  Copyright © 2019 Lev Kolesnikov. All rights reserved.
//

public enum PizzaType: String {
    case fourCheeses = "4 сыра"
    case meat = "Мясная"
    case margherita = "Маргарита"
}

enum PizzaSize {
    case small
    case medium
    case big
}

enum PizzaDough {
    case traditional
    case thin
}

enum PizzaBoard: Int {
    case base = 0
    case cheesy = 40
    case sausage = 50
}

enum Ingredient: String {
    case dough = "Тесто"
    case tomatoSause = "Томатный соус"
    case parmezan = "Пармезан"
    case mozzarella = "Моцарелла"
    case cheddar = "Чеддар"
    case rockforty = "Рокфорти"
    case pepperoni = "Пепперони"
    case beef = "Говядина"
    case chiken = "Курица"
    case tomatoes = "Томаты"
    case beacon = "Бекон"
    case oregano = "Орегано"
    
    var ingredientPrice: Int {
        switch self {
        case .dough:
            return 5
        case .tomatoSause:
            return 10
        case .parmezan:
            return 15
        case .mozzarella:
            return 15
        case .cheddar:
            return 12
        case .rockforty:
            return 20
        case .pepperoni:
            return 15
        case .beef:
            return 20
        case .chiken:
            return 15
        case .tomatoes:
            return 10
        case .beacon:
            return 20
        case .oregano:
            return 5
        }
    }
}

protocol PizzaProtocol {
    var name: PizzaType { get }
    var size: PizzaSize { get }
    var dough: PizzaDough { get }
    var board: PizzaBoard { get }
    var ingredients: [Ingredient] { get }
    var price: Int { get }
}

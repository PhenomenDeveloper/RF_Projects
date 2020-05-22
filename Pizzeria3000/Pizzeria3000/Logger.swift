//
//  Logger.swift
//  Pizzeria3000
//
//  Created by Lev Kolesnikov on 24.11.2019.
//  Copyright © 2019 Lev Kolesnikov. All rights reserved.
//

protocol LogDelegate {
    var delegate: Logger { get }
}

class Logger {
    // MARK: - Использование Singleton
    static let shared = Logger()
    var pizzeriaProfit: Int = 0
    var pizzeriaStatistics: Dictionary <PizzaType, Int> = [:]
    
    
    private init() {}
    
    func printLog (logMessage: String) {
        print(" 📝 " + logMessage)
    }
    
    func printPizzeriaMenu() {
        print(" Наша пиццерия может приготовить следующие виды пицц: \(PizzaType.fourCheeses.rawValue), \(PizzaType.meat.rawValue), \(PizzaType.margherita.rawValue) 🍕")
    }
    
    func printPizzeriaProfit() {
        print("\n Пиццерия принесла своему владельцу: \(pizzeriaProfit)₽ 🧔")
    }
    
    func printPizzeriaStatistics() {
        print("\n Статистика заказов от нашего шеф-повара 👨‍🍳")
        var str: String = ""
        for pizza in pizzeriaStatistics {
            str += "\n 🛒 Пиццу \(pizza.key.rawValue) заказали \(pizza.value)шт.\n"
        }
        print(str)
    }
}

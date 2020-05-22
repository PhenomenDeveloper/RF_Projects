//
//  Client.swift
//  Pizzeria3000
//
//  Created by Lev Kolesnikov on 24.11.2019.
//  Copyright © 2019 Lev Kolesnikov. All rights reserved.
//

enum ClientBalanceMood: String {
    case happy = "😎"
    case tolerably = "🤨"
    case sad = "😔"
}

protocol ClientProtocol {
    var name: String { get }
    var balance: Int { get }
    func orderPizza(pizza: PizzaType)
}

class Client: ClientProtocol {
    var name: String
    var balance: Int
    
    init(name: String, balance: Int) {
        self.name = name
        self.balance = balance
    }
    
    func orderPizza(pizza: PizzaType) {
        
        switch pizza {
        case .fourCheeses:
            let four: FourCheesesPizza = FourCheesesPizza()
            
            Logger.shared.printLog(logMessage: "Клиент хочет заказать пиццу \(four.type.rawValue) 🧀")
            
            if canClientPay(pizzaPrice: four.getPizzaPrice(), balance: balance) {
                Logger.shared.printLog(logMessage: "\(four.getPizzaDescription())")
                Logger.shared.printLog(logMessage: "Сумма заказа: \(four.getPizzaPrice())₽ 🏷")
                Logger.shared.printLog(logMessage: "Баланс клиента до покупки пиццы: \(balance)₽ \(checkBalanceMood(balance: balance))")
                
                balance -= four.getPizzaPrice()
                Logger.shared.pizzeriaProfit += four.getPizzaPrice()
                Logger.shared.printLog(logMessage: "Баланс клиента после покупки пиццы: \(balance)₽ \(checkBalanceMood(balance: balance))")
            } else {
                Logger.shared.printLog(logMessage: "Недостаточно средств : \(balance)₽ 😱")
            }
            
        case .meat:
            let meat: MeatPizza = MeatPizza()
            
            Logger.shared.printLog(logMessage: "Клиент хочет заказать пиццу \(meat.type.rawValue) 🥩")
            
            if canClientPay(pizzaPrice: meat.getPizzaPrice(), balance: balance) {
                Logger.shared.printLog(logMessage: "\(meat.getPizzaDescription())")
                Logger.shared.printLog(logMessage: "Сумма заказа : \(meat.getPizzaPrice())₽ 🏷")
                Logger.shared.printLog(logMessage: "Баланс клиента до покупки пиццы: \(balance)₽ \(checkBalanceMood(balance: balance))")
                
                balance -= meat.getPizzaPrice()
                Logger.shared.pizzeriaProfit += meat.getPizzaPrice()
                Logger.shared.printLog(logMessage: "Баланс клиента после покупки пиццы: \(balance)₽ \(checkBalanceMood(balance: balance))")
            } else {
                Logger.shared.printLog(logMessage: "Недостаточно средств: \(balance)₽ 😱")
            }
            
        case .margherita:
            let margherita: MargheritaPizza = MargheritaPizza()
            
            Logger.shared.printLog(logMessage: "Клиент хочет заказать пиццу \(margherita.type.rawValue) 🧈")
            
            if canClientPay(pizzaPrice: margherita.getPizzaPrice(), balance: balance) {
                Logger.shared.printLog(logMessage: "\(margherita.getPizzaDescription())")
                Logger.shared.printLog(logMessage: "Сумма заказа: \(margherita.getPizzaPrice()) 🏷")
                Logger.shared.printLog(logMessage: "Баланс клиента до покупки пиццы: \(balance)₽ \(checkBalanceMood(balance: balance))")
                
                balance -= margherita.getPizzaPrice()
                Logger.shared.pizzeriaProfit += margherita.getPizzaPrice()
                Logger.shared.printLog(logMessage: "Баланс клиента после покупки пиццы: \(balance)₽ \(checkBalanceMood(balance: balance))")
            } else {
                Logger.shared.printLog(logMessage: "Недостаточно средств: \(balance)₽ 😱")
            }
        }
    }
    
    private func canClientPay(pizzaPrice: Int, balance: Int) -> Bool {
        return balance > pizzaPrice
    }
    
    private func checkBalanceMood(balance: Int) -> String {
        switch balance {
        case 0...100:
            return ClientBalanceMood.sad.rawValue
        case 100...200:
            return ClientBalanceMood.tolerably.rawValue
        case 200...:
            return ClientBalanceMood.happy.rawValue
        default:
            return ClientBalanceMood.happy.rawValue
        }
    }
}

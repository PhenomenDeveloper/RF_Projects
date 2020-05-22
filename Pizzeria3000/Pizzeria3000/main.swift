//
//  main.swift
//  Pizzeria3000
//
//  Created by Lev Kolesnikov on 24.11.2019.
//  Copyright © 2019 Lev Kolesnikov. All rights reserved.
//

// MARK: - Создание действующих лиц
let pizzeria: Pizzeria = Pizzeria()
let client: Client = Client(name: "Лев", balance: 300)
let director: Director = Director()
let chef: Chef = Chef()

// MARK: - Печать меню
Logger.shared.printPizzeriaMenu()

// MARK: - Делаем заказы
client.orderPizza(pizza: .fourCheeses)
pizzeria.addPizzaOrderForStatistics(type: .fourCheeses)

print()

client.orderPizza(pizza: .meat)
pizzeria.addPizzaOrderForStatistics(type: .meat)

print()


client.orderPizza(pizza: .margherita)
pizzeria.addPizzaOrderForStatistics(type: .margherita)

print()

client.orderPizza(pizza: .fourCheeses)
pizzeria.addPizzaOrderForStatistics(type: .fourCheeses)

// MARK: - Смотрим статистику

// запрос дохода пиццерии
director.getProfit()

// запрос статистики заказов пицц
chef.getPizzaOrdersStatistics()




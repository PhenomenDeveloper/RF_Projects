//
//  PizzaStrategy.swift
//  Pizzeria3000
//
//  Created by Lev Kolesnikov on 24.11.2019.
//  Copyright © 2019 Lev Kolesnikov. All rights reserved.
//

// MARK: - Использование паттерна Strategy

protocol PizzaStrategy {
    var type: PizzaType  { get }
    func getPizzaDescription() -> String
    func getPizzaPrice() -> Int
}

//final class AnyPizza {
//    var pizzaStrategy: PizzaStrategy?
//
//    func makePizza() {
//
//    }
//}

final class FourCheesesPizza: PizzaStrategy {
    var type: PizzaType = .fourCheeses
    let fourCheeses: FourCheesesPizzaDecorator = FourCheesesPizzaDecorator(basePizza: BasePizzaIngredients())
    
    func getPizzaDescription() -> String {
        return "Пицца \(type.rawValue) состоит из следующих ингредиентов : " + fourCheeses.addIngredients()
    }
    
    func getPizzaPrice() -> Int {
        return fourCheeses.calculatePrice()
    }
}

final class MeatPizza: PizzaStrategy {
    var type: PizzaType = .meat
    let meat: MeatPizzaDecorator = MeatPizzaDecorator(basePizza: BasePizzaIngredients())
    
    func getPizzaDescription() -> String {
        return "Пицца \(type.rawValue) состоит из следующих ингредиентов : " + meat.addIngredients()
    }
    
    func getPizzaPrice() -> Int {
        return meat.calculatePrice()
    }
}

final class MargheritaPizza: PizzaStrategy {
    var type: PizzaType = .margherita
    let margherita: MargheritaPizzaDecorator = MargheritaPizzaDecorator(basePizza: BasePizzaIngredients())

    func getPizzaDescription() -> String {
        return "Пицца \(type.rawValue) состоит из следующих ингредиентов : " + margherita.addIngredients()
    }
    
    func getPizzaPrice() -> Int {
        return margherita.calculatePrice()
    }
}

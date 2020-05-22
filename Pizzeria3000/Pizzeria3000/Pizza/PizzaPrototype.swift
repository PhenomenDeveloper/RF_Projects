//
//  PizzaPrototype.swift
//  Pizzeria3000
//
//  Created by Lev Kolesnikov on 24.11.2019.
//  Copyright © 2019 Lev Kolesnikov. All rights reserved.
//

// MARK: - Использование паттерна Prototype

final class DefaultPizzaIngredients {
    var ingredients: String
    var price: Int
    var dough: PizzaDough
    
    init() {
        let configurator = PizzaConfigurator()
        self.ingredients = configurator.getDefaultIngredintConfig()
        self.price = configurator.getDefaultPrice()
        self.dough = configurator.getDefaultDough()
    }
    
    init(object: DefaultPizzaIngredients) {
        self.ingredients = object.ingredients
        self.price = object.price
        self.dough = object.dough
    }
    
    func clone() -> DefaultPizzaIngredients {
        return DefaultPizzaIngredients(object: self)
    }
    
}

final class PizzaConfigurator {
    func getDefaultIngredintConfig() -> String {
        return "\(Ingredient.dough.rawValue)," + " \(Ingredient.tomatoSause.rawValue)"
    }
    
    func getDefaultPrice() -> Int {
        return Ingredient.dough.ingredientPrice + Ingredient.tomatoSause.ingredientPrice
    }
    
    func getDefaultDough() -> PizzaDough {
        return PizzaDough.thin
    }
    
}

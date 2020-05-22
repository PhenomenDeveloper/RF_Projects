//
//  PizzaDecorator.swift
//  Pizzeria3000
//
//  Created by Lev Kolesnikov on 24.11.2019.
//  Copyright © 2019 Lev Kolesnikov. All rights reserved.
//

// MARK: - Использование паттерна Decorator

protocol PizzaIngredients {
    func addIngredients() -> String
    func calculatePrice() -> Int
    func choiceDough() -> PizzaDough
}

final class BasePizzaIngredients: PizzaIngredients {
    
    var defaultConfiguration = DefaultPizzaIngredients()
    
    func addIngredients() -> String {
        return defaultConfiguration.ingredients
    }
    
    func calculatePrice() -> Int {
        return defaultConfiguration.price
    }
    
    func choiceDough() -> PizzaDough {
        return defaultConfiguration.dough
    }
    
}

class PizzaIngredientsDecorator: PizzaIngredients {
    
    private var basePizza: PizzaIngredients
    
    init(basePizza: PizzaIngredients) {
        self.basePizza = basePizza
    }
    
    func addIngredients() -> String {
        return basePizza.addIngredients()
    }
    
    func calculatePrice() -> Int {
        return basePizza.calculatePrice()
    }
    
    func choiceDough() -> PizzaDough {
        return basePizza.choiceDough()
    }
    
}

final class FourCheesesPizzaDecorator: PizzaIngredientsDecorator {
    override func addIngredients() -> String {
        super.addIngredients() + ", \(Ingredient.cheddar.rawValue)" + ", \(Ingredient.parmezan.rawValue)"  + ", \(Ingredient.mozzarella.rawValue)"  + ", \(Ingredient.rockforty.rawValue)"
    }
    
    override func calculatePrice() -> Int {
        super.calculatePrice() + Ingredient.cheddar.ingredientPrice + Ingredient.parmezan.ingredientPrice + Ingredient.mozzarella.ingredientPrice + Ingredient.rockforty.ingredientPrice
    }
}

final class MeatPizzaDecorator: PizzaIngredientsDecorator {
    override func addIngredients() -> String {
        super.addIngredients() + ", \(Ingredient.beef.rawValue)" + ", \(Ingredient.chiken.rawValue)"  + ", \(Ingredient.mozzarella.rawValue)"  + ", \(Ingredient.beacon.rawValue)"
    }
    
    override func calculatePrice() -> Int {
        super.calculatePrice() + Ingredient.beef.ingredientPrice + Ingredient.chiken.ingredientPrice + Ingredient.mozzarella.ingredientPrice + Ingredient.beacon.ingredientPrice
    }
}

final class MargheritaPizzaDecorator: PizzaIngredientsDecorator {
    override func addIngredients() -> String {
        super.addIngredients() + ", \(Ingredient.mozzarella.rawValue)" + ", \(Ingredient.tomatoes.rawValue)"  + ", \(Ingredient.oregano.rawValue)"
    }
    
    override func calculatePrice() -> Int {
        super.calculatePrice() + Ingredient.mozzarella.ingredientPrice + Ingredient.tomatoes.ingredientPrice + Ingredient.oregano.ingredientPrice
    }
}

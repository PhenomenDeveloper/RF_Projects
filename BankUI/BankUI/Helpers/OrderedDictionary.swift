//
//  OrderedDictionary.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 14.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

///Словарь упорядоченный по порядку добавления ключей (Обычный словарь может поставить новый элемент в любое место)
struct OrderedDictionary<Tk: Hashable, Tv> {

    ///Ключи
    var keys: [Tk] = []
    ///Значения
    var values: [Tk: Tv] = [:]

    ///Количество ключей
    var count: Int {
        guard keys.count == values.count else {
            print("Количества ключей должны совпадать")
            return -1
        }
        return keys.count
    }

    ///Первое значение ключа
    var first: Tk? {
        return keys.first
    }

    init() {}

    mutating func insert(at index: Int, key: Tk, value: Tv) {
        keys.insert(key, at: index)
        values[key] = value
    }

    subscript(index: Int) -> Tv? {
        get {
            let key = self.keys[index]
            return self.values[key]
        }
        set(newValue) {
            let key = self.keys[index]
            if newValue != nil {
                self.values[key] = newValue
            } else {
                self.values.removeValue(forKey: key)
                self.keys.remove(at: index)
            }
        }
    }

    subscript(key: Tk) -> Tv? {
        get {
            return self.values[key]
        }
        set(newValue) {
            if newValue == nil {
                self.values.removeValue(forKey: key)
                self.keys = self.keys.filter {$0 != key}
            } else {
                let oldValue = self.values.updateValue(newValue!, forKey: key)
                if oldValue == nil {
                    self.keys.append(key)
                }
            }
        }
    }
}
